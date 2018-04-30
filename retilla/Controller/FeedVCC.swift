//
//  FeedVCC.swift
//  retilla
//
//  Created by satkis on 1/27/18.
//  Copyright © 2018 satkis. All rights reserved.
//
import UIKit
import Firebase

class FeedVCC: UITableViewController {
    
    let categories = ["0", "1", "2", "3"]
    var posts = [Post]()
    static var imageCache = NSCache<AnyObject, AnyObject>()
    var post: Post!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // NEED TO FIX: when halfway slide back Back button(navigation) dissapears
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        
        // posts.removeAll()
        //even this is in viewdidload, below will be called only when data changes
        DataService.instance.URL_POSTS.observe(.value) { (snapshot) in
            print(snapshot.value as Any)
            self.posts = []
            
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
                        
                        self.posts.insert(post, at: 0)
                        
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
        let post = posts[indexPath.row]
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
        
return posts.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = posts[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? PostCell
        
        
        var image: UIImage?
        
        image = nil
       
        if let url = post.imageUrl {
        image = FeedVCC.imageCache.object(forKey: url as AnyObject) as? UIImage
        }
        cell?.configureCell(post: post, image: image)
//
//        if collectionView.tag == 0 && post.sectionNumber == 0 {
//            return cell!
//        } else {
//            if collectionView.tag == 1 && post.sectionNumber == 1 {
//                return cell!
//            } else {
//                if collectionView.tag == 2 && post.sectionNumber == 2 {
//                    return cell!
//                } else {
//                    if collectionView.tag == 3 && post.sectionNumber == 3 {
//                        return cell!
//                    }
//                }
//            }
//        }
        
        return cell!
        
        }
    
    
        
        
        
        
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


