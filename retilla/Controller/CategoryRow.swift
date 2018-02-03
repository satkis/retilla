//
//  PostCell.swift
//  retilla
//
//  Created by satkis on 1/23/18.
//  Copyright © 2018 satkis. All rights reserved.
//
import UIKit
import Firebase

//Create a delegate protocol
//protocol CellCollectionViewDelegate: class {
//    func didSelect()
//}

class CategoryRow: UITableViewCell {
    
//    var showDetail:ShowDetailDelegate? = nil
   // var didSelectAction: () -> Void = {}
    
   // weak var delegate: CellCollectionViewDelegate?
    
    @IBOutlet weak private var collectionViewww: UICollectionView!
    
    
    
    var posts = [Post]()
    //var selectedPostt: Post?
    
    
    
    // NSCache dictionary first AnyObject is url of image (aka key), 2nd AnyObject is image data (aka value)
    //    static var imageCache = NSCache<AnyObject, AnyObject>()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionViewww.delegate = self
        self.collectionViewww.dataSource = self
        
        
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
    
    
    
    //identify which postcell was selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let posty: Post!
        
        
        posty = posts[indexPath.row]
        print("tappppedddd::: \(posty)")
        // self.performSegue(withIdentifier: SEGUE_POSTDETAILVC, sender: posty)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 221
    }
    

    
    //identify which postcell was selected
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("indexpathITEM::: \(indexPath.item)")
//        print("collectionViewTag::: \(collectionViewww.tag)")
//        //self.selectedPostt = self.posts
//        var tableViewIndex = collectionViewww.tag
    
    
//        func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//            if (collectionView.cellForItem(at: indexPath as IndexPath) as? PostCell) != nil {
//                let displayText = "selected cell number: \(indexPath.row) from category: (selectedCell.categoryName)"
//                showDetail?.showDetail(display: displayText)
//            }
//        }
        
        
        
        
//        let selectedPost = posts[indexPath.item]
//        let destinationVC = PostDetailVC()
//        destinationVC.post = selectedPost
//        if let
        
        
//        let selectedPost: Post!
//        selectedPost = posts[indexPath.item]
        

        
      //  posty = posts[indexPath.section,indexPath.row]
        
//        let pathh = self.collectionViewww.indexPath(for: posty)

        //posty = posts[indexPath.row]
       // print("tappppedddd::: \(posty)")
        //self.performSegue(withIdentifier: SEGUE_POSTDETAILVC, sender: selectedPost)
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let selectedCell = collectionView.cellForItem(at: indexPath as IndexPath) as? PostCell {
//            let displayText = "selected cell number: \(indexPath.row) from category: \(selectedCell.tag)"
//            showDetailDelegate?.showDetail(displayText: displayText)
//                    print("indexpathITEM::: \(indexPath.item)")
//                    print("collectionViewTag::: \(collectionViewww.tag)")
//                    print("selectedCELL::: \(selectedCell.tag)")
//        }
//    }
//
//
    
    

    
    

