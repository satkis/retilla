//
//  FeedVCC.swift
//  retilla
//
//  Created by satkis on 1/27/18.
//  Copyright © 2018 satkis. All rights reserved.
//
import UIKit
import Firebase

//protocol ShowDetailDelegate {
//    func showDetail(displayText:String)
//}

//protocol ShowDetailDelegate {
//    func showDetail(display: Any)
//}

class FeedVCC: UITableViewController {
    
    var categories = ["Recycle", "Reuse", "Reduce", "Pollution"]
    var posts = [Post]()
    
    //@IBOutlet weak var tableViewwww: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CategoryRow.collectionView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
 
    }
    
    
    
}


//extension FeedVCC : ShowDetailDelegate {
//    func showDetail(display: Any) {
//        performSegue(withIdentifier: SEGUE_POSTDETAILVC, sender: posts)
//    }
//
//
//
//
//}




    

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let detailPage = segue.destination as? PostDetailVC
//           // let displayString = sender
//        {
//            detailPage.selectedPost =
//
//        }
//    }


    
    
    
    
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

