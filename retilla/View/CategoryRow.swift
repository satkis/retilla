//
//  PostCell.swift
//  retilla
//
//  Created by satkis on 1/23/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit
import Firebase

class CategoryRow: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    

    @IBOutlet weak private var collectionViewww: UICollectionView!
    
    
    var posts = [Post]()


    override func awakeFromNib() {
        super.awakeFromNib()

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
                                self.posts.append(post)
                            }

                        }
                    }


                    self.collectionViewww.reloadData()
                }

    }


    
    override func draw(_ rect: CGRect) {
        //google. not sure why to round corenrs in draw rect override and not awakefromnib

        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let post = posts[indexPath.row]
        print("POST STORY::: \(post.postStory as Any)")
        print("SECTION NUMBER::: \(post.sectionNumber)")
        
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! UICollectionViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 221
    }
    
    

}