//
//  PostDetailVC.swift
//  retilla
//
//  Created by satkis on 1/27/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit

class PostDetailVCC: UIViewController, CellDelegate {
    
    
    
    
    var post: Post!
    
//    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        descLabel.text = post.hashtag
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(showDataReceivedFromCollectionViewCell(notification:)), name: NSNotification.Name(rawValue: "myNotification"), object: nil)
        //    print("detailVCC: \(NSNotification.Name(rawValue: "myNotification"))")
        // descriptionLbl.text = "kaka"
        //descriptionLbl.text = post.hashtag
    }
    
    func colCategorySelected(_ indexPath: IndexPath) {
        print("detailVCCC::: \(indexPath)")
    }
    
    //    @objc func showDataReceivedFromCollectionViewCell(notification: Notification) {
    //        if let message = notification.userInfo {
    //            if let msg = message["message"] as? String {
    //                self.descriptionLbl.text = msg
    //                print("detailVCC: \(msg)")
    //            }
    //        }
    //    }
    
    //    func didSelect(data: String) {
    //        descriptionLbl.text = post.hashtag
    //        print("postDetailVC Post::: \(Post.self)")
    //        print("#2 postDetailVC data::: \(data)")
    //    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        //        if let cell = sender as? PostCell {
    //        if segue.identifier == SEGUE_POSTDETAILVC {
    //            let sendingVC: FeedVCC = segue.destination as! FeedVCC
    //            //                detailScreen.descriptionLbl.text = post.hashtag
    //            sendingVC.delegatee = self
    //            print("delegate value in PostDetailVC \(String(describing: sendingVC.delegatee))")
    //        }
    //        //        }
    //    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

