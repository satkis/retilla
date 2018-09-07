//
//  PostCellIInCollection.swift
//  retilla
//
//  Created by satkis on 1/26/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit

import Alamofire
import AlamofireImage
import Firebase

class PostCell: UICollectionViewCell {
    
    var post: Post!
    var request: Request?
    var reactionRef: DatabaseReference!
    var imageUrlString: String?
    
    
    
    
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var postDateLbl: UILabel!
    
    @IBOutlet weak var postImg: UIImageView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var commentsCountLbl: UILabel!
    
    @IBOutlet weak var readStoryLbl: UILabel!
    
    @IBOutlet weak var postCellContainer: UIView!
    //@IBOutlet weak var reactionCountLbl: UILabel!
    
    //@IBOutlet weak var reactionImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        animationWhileImgLoading()
 
    }
  
    
    func animationWhileImgLoading() {
        
        postCellContainer.backgroundColor = UIColor(white: 1, alpha: 0.1)
        let darkItem = UILabel()
        darkItem.backgroundColor = UIColor(white: 1, alpha: 0.5)
        darkItem.frame = CGRect(x: 0, y: 0, width: 500, height: 800)
        postCellContainer.addSubview(darkItem)
        postCellContainer.sendSubview(toBack: darkItem)
        
        let shinyItem = UILabel()
        shinyItem.backgroundColor = UIColor.white
        shinyItem.frame = CGRect(x: -150, y: 0, width: 500, height: 200)
        postCellContainer.addSubview(shinyItem)
        postCellContainer.sendSubview(toBack: shinyItem)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.frame = shinyItem.frame
        
        let angle = 135 * CGFloat.pi / 180
        gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
        shinyItem.layer.mask = gradientLayer
        
        //animation
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.speed = 0.15
        
        animation.fromValue = -postCellContainer.frame.width
        animation.toValue = postCellContainer.frame.width+250
        animation.repeatCount = Float.infinity
        
        gradientLayer.add(animation, forKey: "doesntmatter")
     
    }
    
    
    func configureCell(post: Post, image: UIImage?) {
     
        self.post = post
        
        reactionRef = DataService.instance.URL_USER_CURRENT.child("reactions").child(post.postKey)
        
        print("printtt: \(reactionRef)")
 
        
        if let location = post.location_country, post.location_country != "" {
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
            if user.contains("Guest") {
                self.userNameLbl.text = "Guest"
            } else {
                self.userNameLbl.text = user
            }
        }
    

        if let postTime = post.timestamp {


            
            let timee = post.timestamp
            let x = timee! / 1000
            let datee = NSDate(timeIntervalSince1970: x)

            print("finalTimeee::", datee.timeAgoDisplay())

            self.postDateLbl.text = datee.timeAgoDisplay()

        } else {
            self.postDateLbl.text = "time n/a"
        }

        if post.imageUrl != "" {
            imageUrlString = post.imageUrl
            self.postImg.image = nil
          
            //if image is not nil, it means it's cached image which is passed. otherwise Alamofire request is needed to download img
            if image != nil {
                self.postImg.image = image
                
            } else {
               
                request = Alamofire.request(post.imageUrl!, method: .get).validate(contentType: ["image/*"]).responseData(completionHandler: { (response) in
                    
                    if let data = response.result.value {
                        
                        let image = UIImage(data: data)!
                        
                        if self.imageUrlString == post.imageUrl {
                            self.postImg.image = image
                        }
                    
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
    
    
}



extension NSDate {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self as Date))
        let minutes2 = 120
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        
        if secondsAgo < minutes2 {
            return "Just now"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) mins ago"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) h ago"
        } else if secondsAgo < week {
            return "\(secondsAgo / day) d ago"
        } else if secondsAgo < month {
            return "\(secondsAgo / week) w ago"
        } else if secondsAgo < year {
            return "\(secondsAgo / month) m ago"
        }
        
        return "\(secondsAgo / year)y ago"
    }
}







