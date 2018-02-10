//
//  PostCell.swift
//  retilla
//
//  Created by satkis on 1/23/18.
//  Copyright © 2018 satkis. All rights reserved.
//
import UIKit
import Firebase

class CategoryRow: UITableViewCell {

    @IBOutlet weak var collectionViewww: UICollectionView!
    
    
    
 //   var posts = [Post]()
    
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//print("awareFromNib")
    
    
//        //even this is in viewdidload, below will be called only when data changes
//        DataService.instance.URL_POSTS.observe(.value) { (snapshot) in
//            print(snapshot.value as Any)
//            self.posts = []
//
//            //this gives us data individual (every post separate array/dict?)
//            //snapshot is like "posts" or "users" in Firebase, and snap is "likes", "hashtag" etc
//            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//                for snap in snapshots {
//                    //print("SNAP::: \(snap)")
//
//                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
//                        //key is user/post ID
//                        let key = snap.key
//                        let post = Post(postKey: key, dictionary: postDictionary)
//                        self.posts.append(post)
//                    }
//                }
//            }
//
//            self.collectionViewww.reloadData()
//            print("awakeFromNib Reload Data")
//        }
//    }
//    }

    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        print("setCollectionViewDataSourceDelegate")
        collectionViewww.delegate = dataSourceDelegate
        collectionViewww.dataSource = dataSourceDelegate
        collectionViewww.tag = row
        collectionViewww.awakeFromNib()
        collectionViewww.reloadData()
    }
    
    override func draw(_ rect: CGRect) {
    }


    
    
    
    
    
    
    
    
    
    
    
    
    
    

    

}

