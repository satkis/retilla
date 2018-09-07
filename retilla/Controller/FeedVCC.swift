import UIKit
import Firebase

struct headerStruct {
    var image: UIImage!
    var name: String!
}

var heightOfHeader : CGFloat = 44

class FeedVCC: UITableViewController {

    var categories = [headerStruct]()
    
    var posts = [[Post]]()
    static var imageCache = NSCache<AnyObject, AnyObject>()
    var post: Post!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         self.navigationController?.setNavigationBarHidden(false, animated: true)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        tableView.dataSource = self
        tableView.delegate = self

        categories = [headerStruct.init(image: #imageLiteral(resourceName: "circle0"), name: "REUSE"),
                      headerStruct.init(image: #imageLiteral(resourceName: "circle1"), name: "RECYCLE"),
                      headerStruct.init(image: #imageLiteral(resourceName: "circle2"), name: "REDUCE"),
                      headerStruct.init(image: #imageLiteral(resourceName: "circle3"), name: "POLLUTION")]
        
        print("USERID_FEEDVC::", UserDefaults.standard.value(forKey: KEY_UID))

        let userIcon = UIImageView(image: #imageLiteral(resourceName: "logoo_darker"))
        userIcon.frame = CGRect(x: 0, y: 0, width: 122, height: 23)
        userIcon.contentMode = .scaleAspectFit
        navigationItem.titleView = userIcon

        DataService.instance.URL_POSTS.observe(.value) { (snapshot) in
            print(snapshot.value as Any)

            self.posts.append([])
            self.posts.append([])
            self.posts.append([])
            self.posts.append([])

            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {

                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        //key is user/post ID
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDictionary)
                        
                        let section = post.sectionNumber?.hashValue

                        self.posts[section!].insert(post, at: 0)
                        
                    }
                }
            }
            
            self.tableView.reloadData()
        }
        print("ViewDidLoad Ended")
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightOfHeader
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as! HeaderView
        
        headerView.headerImageView.image = categories[section].image
        headerView.headerLabel.text = categories[section].name
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categoryRoww = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryRow
        
        print("cellForRowAt indexPath")
        return categoryRoww
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("WillDisplay")
        guard let categoryRoww = cell as? CategoryRow else { return }
        
        categoryRoww.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
        print("willDisplay Ended")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare for Segue")
        if segue.identifier == SEGUE_POSTDETAILVC {
            print("Segue identified is for PostDetailVCC")
            let detailVC = segue.destination as? PostDetailVCC
            
            if let posty = sender as? Post {
                detailVC?.post = posty
            }
        }
    }
    
    
    
    
}



extension FeedVCC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //identify which postcell was selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("collectionView.tag", collectionView.tag)
        debugPrint("indexPath.item", indexPath.item)
        let post = posts[collectionView.tag][indexPath.row]
        self.performSegue(withIdentifier: SEGUE_POSTDETAILVC, sender: post)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return posts[collectionView.tag].count
        print("NumberOfItemsInSection:::::")

        print("collectionView.taggg:::: \(collectionView.tag)")

        
        if posts.count > 0 {
            return posts[collectionView.tag].count
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = posts[collectionView.tag][indexPath.row]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? PostCell {

        cell.request?.cancel()
            
        cell.contentView.layer.cornerRadius = 8.0
        cell.contentView.clipsToBounds = true
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        cell.layer.shadowRadius = 5.0

        var image: UIImage?

        if let url = post.imageUrl {
            image = FeedVCC.imageCache.object(forKey: url as AnyObject) as? UIImage

        }
        cell.configureCell(post: post, image: image)

        
        return cell
        } else {
            return PostCell()
        }
    }

    
}
