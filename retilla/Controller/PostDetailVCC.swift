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
        
        if post.likes != nil {
            likesLbl.text = "\(String(describing: post.likes))"
        } else {
            likesLbl.text = "NO likes found"
        }
        
        if post.username != nil {
            usernameLbl.text = post.username
        } else {
            likesLbl.text = "NO username found"
        }
        
        //need to correct: image downloads, but needs to be taken from cache (otherwise need to wait until downloads
        if post.imageUrl != nil {
        //let imageView = UIImageView()
        let data = NSData(contentsOf: NSURL(string: post.imageUrl!)! as URL)
        
        imageLbl.image = UIImage(data: data! as Data)

        } else {
            return
        }

       
    }

    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

