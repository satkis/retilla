//
//  PostDetailVC.swift
//  retilla
//
//  Created by satkis on 1/27/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit
import MapKit

class PostDetailVCC: UIViewController {

    var post: Post!
    
    @IBOutlet weak var map: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    
    @IBOutlet weak var postStoryLbl: UILabel!
    @IBOutlet weak var hashtagLbl: UILabel!
    @IBOutlet weak var coordinatesLbl: UILabel!
    @IBOutlet weak var imageUrlLbl: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var sectionNumberLbl: UILabel!
    
    @IBOutlet weak var postTimestampLbl: UILabel!
    
   
    @IBOutlet weak var imageLbl: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        
        self.navigationController?.isNavigationBarHidden = false
        self.title = "some"
        
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
            coordinatesLbl.text = post.coordinatesGps
        } else {
            coordinatesLbl.text = "n/a coordinates"
        }
        
        if post.imageUrl != nil {
            imageUrlLbl.text = post.imageUrl
        } else {
            imageUrlLbl.text = "n/a URL"
        }
        
        self.likesLbl.text = "\(post.likes)"
        
//        if let likes = post.likes, post.likes != nil {
//            likesLbl.text = String(likes)
//        } else {
//            likesLbl.text = "n/a likes"
//        }
        
        if post.username != nil {
            usernameLbl.text = post.username
        } else {
            usernameLbl.text = "n/a username"
        }
        
        if post.timestamp != nil {
            postTimestampLbl.text = "\(post.timestamp!.prefix(6))"
        } else {
            postTimestampLbl.text = "n/a time"
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







extension PostDetailVCC: MKMapViewDelegate {
    
//    func centerMapOnLocation(locationL CLLocation) {
//        let coordinateRegion  MKCoordinateRegionMakeWithDistance(location , <#T##latitudinalMeters: CLLocationDistance##CLLocationDistance#>, <#T##longitudinalMeters: CLLocationDistance##CLLocationDistance#>)
//    }
    
    
    
    
    
}






