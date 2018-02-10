//
//  PostDetailVC.swift
//  retilla
//
//  Created by satkis on 1/27/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit

class PostDetailVCC: UIViewController {

    var post: Post!
    
    @IBOutlet weak var postStoryLbl: UILabel!
    @IBOutlet weak var hashtagLbl: UILabel!
    @IBOutlet weak var coordinatesLbl: UILabel!
    @IBOutlet weak var imageUrlLbl: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var sectionNumberLbl: UILabel!
    
   
    @IBOutlet weak var imageLbl: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        if post.postStory != nil {
            postStoryLbl.text = post.postStory
        } else {
            postStoryLbl.text = "NO story found"
        }
  
        if post.hashtag != nil {
            hashtagLbl.text = post.hashtag
        } else {
            hashtagLbl.text = "NO hashtag found"
        }
        
        if post.coordinatesGps != nil {
            coordinatesLbl.text = "\(String(describing: post.coordinatesGps))"
        } else {
            coordinatesLbl.text = "NO coordinates found"
        }
        
        if post.imageUrl != nil {
            imageUrlLbl.text = post.imageUrl
        } else {
            imageUrlLbl.text = "NO URL found"
        }
        
        if let likes = post.likes, post.likes != nil {
            likesLbl.text = String(likes)
        } else {
            likesLbl.text = "NO likes found"
        }
        
        if post.username != nil {
            usernameLbl.text = post.username
        } else {
            usernameLbl.text = "NO username found"
        }

        // NEED TO adjust if image fails to download (make default value)
        if post.imageUrl != nil {
        let cacheImage = FeedVCC.imageCache.object(forKey: post.imageUrl as AnyObject) as? UIImage
        imageLbl.image = cacheImage
        } else {
           return
            
        }

       
    }

    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

