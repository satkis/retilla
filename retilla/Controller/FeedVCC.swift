import UIKit
import Firebase

struct headerStruct {
    var image: UIImage!
    var name: String!
}

var heightOfHeader : CGFloat = 44

class FeedVCC: UITableViewController {
    
//    let categories = ["REUSE", "RECYCLE", "REDUCE", "POLLUTION"]
    var categories = [headerStruct]()
    
    var posts = [[Post]]()
    static var imageCache = NSCache<AnyObject, AnyObject>()
    var post: Post!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         self.navigationController?.hidesBarsOnSwipe = true
        
        
//        headerView.headerLabel.text
        
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
        //self.title = "home"
        
        
        
        
        let userIcon = UIImageView(image: #imageLiteral(resourceName: "userIcon"))
        userIcon.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        userIcon.contentMode = .scaleAspectFit
        navigationItem.titleView = userIcon
        
        self.navigationController?.isNavigationBarHidden = false
        
        // posts.removeAll()
        //even this is in viewdidload, below will be called only when data changes
        DataService.instance.URL_POSTS.observe(.value) { (snapshot) in
            print(snapshot.value as Any)
            //self.posts = []
            //self.posts.removeAll()
            self.posts.append([])
            self.posts.append([])
            self.posts.append([])
            self.posts.append([])
            
            
            //this gives us data individual (every post separate array/dict?)
            //snapshot is like "posts" or "users" in Firebase, and snap is "likes", "hashtag" etc
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    print("SNAP::: \(snap)")
                    
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        //key is user/post ID
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDictionary)
                        
                        let section = post.sectionNumber?.hashValue
                        print("SECTIONN: \(String(describing: section))")
                        
                        //self.posts.insert(post, at: 0)

                        self.posts[section!].insert(post, at: 0)
                        
                    }
                }
            }
            
            self.tableView.reloadData()
        }
        print("ViewDidLoad Ended")
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // guard posts.count != 0 else { return 1 }
        //        return posts.count
        return categories.count
        //        return 1
    }
    
    //    func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        return categories.count
    //    }
    
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label: UILabel = UILabel()
//
//        label.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
//        return label
//    }
    
    
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//
//        let headerLabel = UILabel(frame: CGRect(x: 30, y: 5, width:
//            tableView.bounds.size.width, height: tableView.bounds.size.height))
//        headerLabel.font = UIFont(name: "Helvetica Neue", size: 21)
//
//        headerLabel.textColor = #colorLiteral(red: 0.5589903236, green: 0.5589903236, blue: 0.5589903236, alpha: 1)
//        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
//        headerLabel.sizeToFit()
//        headerView.addSubview(headerLabel)
//
//
//        return headerView
//    }
    


    
    
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//        return categories[section]
//    }
    
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
        //        let post = posts[collectionView.tag][indexPath.item]
        debugPrint("collectionView.tag", collectionView.tag)
        debugPrint("indexPath.item", indexPath.item)
        let post = posts[collectionView.tag][indexPath.row]
        self.performSegue(withIdentifier: SEGUE_POSTDETAILVC, sender: post)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return posts[collectionView.tag].count
        print("NumberOfItemsInSection:::::")
        //var postt: Post!
        
        print("collectionView.taggg:::: \(collectionView.tag)")
        //        if collectionView.tag == 0 && postt.sectionNumber == 0 {
        //            return posts.count
        //        } else if collectionView.tag == 1 && postt.sectionNumber == 1 {
        //            return posts.count
        //        } else if collectionView.tag == 2 && postt.sectionNumber == 2 {
        //            return posts.count
        //        } else if collectionView.tag == 3 && postt.sectionNumber == 3 {
        //            return posts.count
        //        }
        
        //return posts.count
        
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
        //cell?.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        cell.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        cell.layer.shadowRadius = 5.0

        var image: UIImage?
        
        //image = nil
       
//        cell?.postImg.image = UIImage(named: post.imageUrl)
        if let url = post.imageUrl {
            image = FeedVCC.imageCache.object(forKey: url as AnyObject) as? UIImage
           
//            cell?.postImg = UIImage(named: post.imageUrl![indexPath.row])
            
        }
        cell.configureCell(post: post, image: image)

        
        return cell
        } else {
            return PostCell()
        }
    }
    //        if collectionView.tag == 0 && post.sectionNumber == 0 {
    //            return cell!
    //        } else if collectionView.tag == 1 && post.sectionNumber == 1 {
    //            return cell1!
    //        } else if collectionView.tag == 2 && post.sectionNumber == 2 {
    //            return cell2!
    //        } else {
    //            return cell3!
    //        }
    //        if collectionView.tag == 0 && post.sectionNumber == 0 {
    //            return cell!
    //        } else if collectionView.tag == 1 && post.sectionNumber == 1 {
    //            return cell1!
    //        } else {
    //            return cell2!
    //        }
    //
    //
    //        }
    
    
    
    
    
    
    //        print("collectionView cellForROwAt indexPath")
    //        //let post = posts[collectionView.tag] //[indexPath.item]
    //
    //        let post = posts[indexPath.row]
    //
    //        print("post.sectionNumber::: \(String(describing: post.sectionNumber))")
    //        print("collectionView.tag \(collectionView.tag)")
    //        print("indexPath.row:::: \(indexPath.row)")
    //
    //        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? PostCell {
    //            //cell.request?.cancel()
    //            var image: UIImage?
    //
    //
    //            if let url = post.imageUrl {
    //                //set image in cache as image(if it exists). if not, then image will be downloaded
    //                image = FeedVCC.imageCache.object(forKey: url as AnyObject) as? UIImage
    //            }
    //            //cell.configureCell(post: posts[collectionView.tag][indexPath.row], image: image)
    //            cell.configureCell(post: post, image: image)
    //
    //            return cell
    //        } else {
    //            return UICollectionViewCell()
    //        }
    //
    //    }
    
    
    
    
    
    
    
    
    
}
