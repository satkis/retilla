//
//  FeedVC.swift
//  retilla
//
//  Created by satkis on 1/23/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var categories = ["Recycle", "Reuse", "Reduce", "Pollution"]
    var posts = [Post]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_POSTDETAILVC {
            let detailVC = segue.destination as? PostDetailVC
            if let posty = sender as? Post {
                detailVC?.post = posty
            }
            
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryRow
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        }
        
    
    
    
    //identify which postcell was selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var posty: Post!
       
        posty = posts[indexPath.item]
        
        self.performSegue(withIdentifier: SEGUE_POSTDETAILVC, sender: posty)
    }
    
    
    
    
    
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == SEGUE_POSTDETAILVC {
//            if let detailVC = segue.destination as? PostDetailVC {
//                if let posty = sender as? Post {
//                    detailVC.post = posty
//                }
//            }
//        }
//    }
//
    
    

    
    


}
