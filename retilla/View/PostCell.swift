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
    
    //@IBOutlet weak var reactionCountLbl: UILabel!
    
    //@IBOutlet weak var reactionImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //need to call this with code. from Storyboard these won't work because this is collection view. also because this is reusable cell
       
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.reactionTapped(_:)))
//        tap.numberOfTapsRequired = 1
//        reactionImg.addGestureRecognizer(tap)
//        reactionImg.isUserInteractionEnabled = true

//        //testing different liking 0603
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onDoubleTap(_:)))
//        gesture.numberOfTapsRequired = 2
//        contentView.addGestureRecognizer(gesture)
//        reactionImg.isUserInteractionEnabled = true
//        reactionImg.isHidden = true
    }
    
//    override func prepareForReuse() {
//        print("prepareforreuse")
//        super.prepareForReuse()
//        postImg.af_cancelImageRequest()
//
////        postImg.layer.removeAllAnimations()
//
//
//        postImg.image = nil
//
//    }
    
    
    func configureCell(post: Post, image: UIImage?) {
        //this function happens when cell is configured. liked/disliked / adjusted, whatever
        self.post = post
        
        reactionRef = DataService.instance.URL_USER_CURRENT.child("reactions").child(post.postKey)
        
        print("printtt: \(reactionRef)")
        //self.reactionCountLbl.text = "\(post.likes!)"
        
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
            if user.contains("Anonymous") {
                self.userNameLbl.text = "Anonymous"
            } else {
                self.userNameLbl.text = user
            }
        }
    
//
//
//        if let user = post.username, post.username != "", user.contains("Anonymous") {
//            self.userNameLbl.text = "Anonymous"
//            } else {
//                self.userNameLbl.text = user
//            } else {
//                self.userNameLbl.text = "no user ID"
//            }
    

        
        if let postTime = post.timestamp, postTime != "" {
            
            let fff = postTime.hashValue
            let kk = post.timestamp as NSString
            let tt = kk.doubleValue
            let converted = Date(timeIntervalSince1970: TimeInterval(fff / 1000))
            let conv = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone.local
            dateFormatter.dateFormat = "yyyy-mm-dd hh:mm:ss"
            let timee = dateFormatter.string(from: converted)
            
            let sss: Double = (postTime as NSString).doubleValue
             print("ss \(sss)")
            
            print("kk \(kk)")
            print("tt \(tt)")
            print("fff \(fff)")
            print("converted \(converted)")
            print("dateFormatter \(dateFormatter)")
            print("timee \(timee)")
            
            
//            let eee = fff.doubleValue
            let ww  = postTime.description
            
            
//            print("eee \(eee)")
            print("ww \(ww)")
          
            
            let now = Date()
            print("dateee \(now)")
            
            //print("fff \(fff)")
            let tii = Double(post.timestamp)
            print("tii \(tii)")
            print("post.timestamp \(post.timestamp)")
//            let pastDate = Date(timeIntervalSinceNow: tt!)
//self.postDateLbl.text = pastDate.timeAgoDisplay()
            
            //let dateee = postTime.Substring(post.timestamp.prefix(6))
            // self.postDateLbl.text = "\(postTime.index(postTime.startIndex, offsetBy: 6))"
    self.postDateLbl.text = "\(postTime.prefix(6))"
            //self.postDateLbl.text = postTime.
        } else {
            self.postDateLbl.text = "n/a"
        }
        
        
        
//        if let imageFromCache = FeedVCC.imageCache.object(forKey: self.post.imageUrl as AnyObject) as? UIImage {
//            self.postImg.image = imageFromCache
//            return
//        }
        
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
        
        
        //observe single event - it checks only ONCE in Firebase if theres any reactions/likes by user.
//        reactionRef.observeSingleEvent(of: .value, with: { snapshot in
//
//            //in Firebase if there's no data, then it's NSNULL. 'nil' won't work
//            if let doesNotExist = snapshot.value as? NSNull {
//                //this means user hasn't liked this specific post
//                self.reactionImg.image = UIImage(named: "heartEmpty")
//
//            } else {
//                //self.reactionImg.image = UIImage(named: "heartFull")
//                self.reactionImg.isHidden = true
//            }
//        })
    }
    
    
//    @objc func reactionTapped(_ sender: UITapGestureRecognizer) {
//        reactionRef.observeSingleEvent(of: .value, with: { snapshot in
//            //in Firebase if there's no data, then it's NSNULL. nil won't work
//            if let doesNotExist = snapshot.value as? NSNull {
//                //this means user hasn't liked this specific post
//                self.reactionImg.isHidden = true
//                self.reactionImg.alpha = 1.0
//
//                //self.reactionImg.image = UIImage(named: "heartFull")
//                self.post.adjustReactions(addReaction: true)
//                self.reactionRef.setValue(true)
//            } else {
//
//                UIView.animate(withDuration: 1.0, delay: 1.0, animations: {
//                    self.reactionImg?.alpha = 0
//
//                }, completion: {
//                    (value:Bool) in
//                    self.reactionImg.isHidden = true
//                })
//
//                //self.reactionImg.image = UIImage(named: "heartEmpty")
//                //self.post.adjustReactions(addReaction: false)
//                //self.reactionRef.removeValue()
//            }
//        })
//    }
    
//    @objc func onDoubleTap(_ sender:AnyObject) {
//        reactionImg.isHidden = false
//        reactionImg.alpha = 1.0
//        UIView.animate(withDuration: 1.0, delay: 1.0, animations: {
//            self.reactionImg?.alpha = 0
//
//        }, completion: {
//            (value:Bool) in
//            self.reactionImg.isHidden = true
//            self.post.adjustReactions(addReaction: true)
//            self.reactionRef.setValue(true)
//        })
//    }
    
    
}



extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        
        if secondsAgo < minute {
            return "Just now"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute)mins ago"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour)h ago"
        } else if secondsAgo < week {
            return "\(secondsAgo / day)d ago"
        } else if secondsAgo < month {
            return "\(secondsAgo / week)w ago"
        } else if secondsAgo < year {
            return "\(secondsAgo / month)m ago"
        }
        
        return "\(secondsAgo / year)y ago"
    }
}







