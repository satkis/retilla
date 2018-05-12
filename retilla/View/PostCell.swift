//
//  PostCellIInCollection.swift
//  retilla
//
//  Created by satkis on 1/26/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UICollectionViewCell {
    
    var post: Post!
    var request: Request?
    var reactionRef: DatabaseReference!
    
    
    
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var postDateLbl: UILabel!
    
    @IBOutlet weak var postImg: UIImageView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var commentsCountLbl: UILabel!
    
    @IBOutlet weak var readStoryLbl: UILabel!
    
    @IBOutlet weak var reactionCountLbl: UILabel!
    
    @IBOutlet weak var reactionImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //need to call this with code. from Storyboard these won't work because this is collection view. also because this is reusable cell
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.reactionTapped(_:)))
        tap.numberOfTapsRequired = 1
        reactionImg.addGestureRecognizer(tap)
        reactionImg.isUserInteractionEnabled = true
    }
    
    
    func configureCell(post: Post, image: UIImage?) {
        //this function happens when cell is configured. liked/disliked / adjusted, whatever
        self.post = post
        
        reactionRef = DataService.instance.URL_USER_CURRENT.child("reactions").child(post.postKey)
        
        print("printtt: \(reactionRef)")
        self.reactionCountLbl.text = "\(post.likes!)"
        
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
        
        if let user = post.username, post.username != "" {
            self.userNameLbl.text = user
        } else {
            self.userNameLbl.text = "no user ID"
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
        
        
        //observe single event - it checks only ONCE in Firebase if theres any reactions/likes by user.
        reactionRef.observeSingleEvent(of: .value, with: { snapshot in
            
            //in Firebase if there's no data, then it's NSNULL. 'nil' won't work
            if let doesNotExist = snapshot.value as? NSNull {
                //this means user hasn't liked this specific post
                self.reactionImg.image = UIImage(named: "heartEmpty")
                
            } else {
                self.reactionImg.image = UIImage(named: "heartFull")
            }
        })
    }
    
    
    @objc func reactionTapped(_ sender: UITapGestureRecognizer) {
        reactionRef.observeSingleEvent(of: .value, with: { snapshot in
            //in Firebase if there's no data, then it's NSNULL. nil won't work
            if let doesNotExist = snapshot.value as? NSNull {
                //this means user hasn't liked this specific post
                self.reactionImg.image = UIImage(named: "heartFull")
                self.post.adjustReactions(addReaction: true)
                self.reactionRef.setValue(true)
            } else {
                self.reactionImg.image = UIImage(named: "heartEmpty")
                self.post.adjustReactions(addReaction: false)
                self.reactionRef.removeValue()
            }
        })
    }
    
    
}
