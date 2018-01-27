//
//  PostCellIInCollection.swift
//  retilla
//
//  Created by satkis on 1/26/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit
import Alamofire


class PostCell: UICollectionViewCell {

    var post: Post!
    var request: Request?
      

    
    
    
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var postDateLbl: UILabel!
    
    @IBOutlet weak var postImg: UIImageView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var commentsCountLbl: UILabel!
    
    @IBOutlet weak var readStoryLbl: UILabel!
    
    @IBOutlet weak var reactionCountLbl: UILabel!
    
    
//    func configureCell(post: Post) {
//        self.post = post
//
//        if let post = post.likes, post.likes != "" {
//        self.reactionCountLbl.text = "\(post.likes)"
//        }
    
    func configureCell(post: Post, image: UIImage?) {
            self.post = post
            
            if let reactionCount = post.likes, post.likes != nil {
            self.reactionCountLbl.text = String(reactionCount)
            } else {
               self.reactionCountLbl.text = String()
            }
        
        if post.imageUrl != "" {
            //if image is not nil, it means it's cached image which is passed. otherwise Alamofire request is needed to download img
            if image != nil {
                self.postImg.image = image
            } else {
                
                request = Alamofire.request(post.imageUrl!, method: .get).validate(contentType: ["image/*"]).responseData(completionHandler: { (response) in
                    
                    if let data = response.result.value {
                        let image = UIImage(data: data)!
                        self.postImg.image = image
                        //add to cache if image was downloaded
                        CategoryRow.imageCache.setObject(image, forKey: self.post.imageUrl as AnyObject)
                    } else {
//                        self.postImg.isHidden = true
                        print("ALAMOFIRE ERROR::: \(response.result.error)")
                    }
                })
            }
            
            
        } else {
            self.postImg.isHidden = true
        }
            
            
            
    }
    
    
//
//    override var isSelected: Bool {
//        didSet{
//            if self.isSelected
//            {
//
//                var posty: Post!
//
//                posty = posts[IndexPath.row]
//
//                print("tap::: \(posty)")
//            }
//            else
//            {
//                print("ERRORRRR::::")
//            }
//        }
//    }
    
    
    
    
    
    
}
