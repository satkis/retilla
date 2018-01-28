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
    
    var categories = ["Recycle", "Reuse", "Reduce", "Pollution"]
    var posts = [Post]()
    
    @IBOutlet weak var tableViewwww: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CategoryRow.collectionView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        //        //even this is in viewdidload, below will be called only when data changes
        //        DataService.instance.URL_POSTS.observe(.value) { (snapshot) in
        //            print(snapshot.value as Any)
        //            self.posts = []
        //
        //            //this gives us data individual (every post separate array/dict?)
        //            //snapshot is like "posts" or "users" in Firebase, and snap is "likes", "hashtag" etc
        //            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
        //                for snap in snapshots {
        //                    print("SNAP::: \(snap)")
        //
        //                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
        //                        //key is user/post ID
        //                        let key = snap.key
        //                        let post = Post(postKey: key, dictionary: postDictionary)
        //                        self.posts.append(post)
        //                    }
        //
        //                }
        //            }
        //
        //
        //            self.tableView.reloadData()
        //        }
        
        
        
    }
}




extension FeedVCC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
//        return categories.count
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //return tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryRow
        
        let categoryRoww = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryRow
        return categoryRoww
    }
    
    

    
    
    
    
    //    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //
    //
    //
    //     collectionViewwwwwwww.dataSource = self
    //        collectionViewwwwwwww.dataSource = self
    //
    //
    //    }
    

    
}



extension CategoryRow : UICollectionViewDataSource, UICollectionViewDelegate {
    
    static var imageCache = NSCache<AnyObject, AnyObject>()
    
    

    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("collecitonViewTag: \(collectionView.tag)")
        return posts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let post = posts[indexPath.row]
        //        var posts = [Post]()
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? PostCell {
            
            cell.request?.cancel()
            
            var image: UIImage?
            
            if let url = post.imageUrl {
                //set image in cache as image(if it exists). if not, then image will be downloaded
                image = CategoryRow.imageCache.object(forKey: url as AnyObject) as? UIImage
            }
            
            cell.configureCell(post: post, image: image)
            return cell
            
        } else {
            return PostCell()
        }
    }
    

    
    
    
    
}


