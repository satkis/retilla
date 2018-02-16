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
    
    
    func configureCell(post: Post, image: UIImage?) {
        self.post = post
        
        if let reactionCount = post.likes, post.likes != nil {
            self.reactionCountLbl.text = String(reactionCount)
        } else {
            self.reactionCountLbl.text = String()
        }
        
        if let location = post.location, post.location != "" {
            self.locationLbl.text = location
        } else {
            self.locationLbl.text = "no location"
        }
        
        if let story = post.postStory, post.postStory != "" {
            self.readStoryLbl.text = "Read story"
        } else {
            self.readStoryLbl.text = ""
        }
        
        if let postTime = post.timestamp, post.timestamp != "" {
            //let dateee = postTime.Substring(post.timestamp.prefix(6))
           // self.postDateLbl.text = "\(postTime.index(postTime.startIndex, offsetBy: 6))"
            self.postDateLbl.text = "\(postTime.prefix(6))"
            //self.postDateLbl.text = postTime.
        } else {
            self.postDateLbl.text = "n/a"
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
                        FeedVCC.imageCache.setObject(image, forKey: self.post.imageUrl as AnyObject)
                    } else {
                        print("ALAMOFIRE ERROR::: \(String(describing: response.result.error))")
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
