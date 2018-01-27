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
        return categories.count
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
    
    //identify which postcell was selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let posty: Post!
        
        posty = posts[indexPath.row]
  
        self.performSegue(withIdentifier: SEGUE_POSTDETAILVC, sender: posty)
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


//
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == SEGUE_POSTDETAILVC {
//            let detailVC = segue.destination as? PostDetailVC
//            if let posty = sender as? Post {
//                detailVC?.post = posty
//            }
//
//        }
//    }


    
    

    
    
    
    
    
    
    
    
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
    
    
    
    
    
    
    



    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


