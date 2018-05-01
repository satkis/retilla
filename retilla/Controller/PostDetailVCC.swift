//
//  PostDetailVC.swift
//  retilla
//
//  Created by satkis on 1/27/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit
import MapKit

class PostDetailVCC: UIViewController, MKMapViewDelegate {

    let annotation = MKPointAnnotation()
    
    var post: Post!
    var lat: CLLocationDegrees = 0.0
    var long: CLLocationDegrees = 0.0
    
    @IBOutlet weak var map: MKMapView!
    //let regionRadius: CLLocationDistance = 1000
    
    @IBOutlet weak var postStoryLbl: UILabel!
    @IBOutlet weak var hashtagLbl: UILabel!
    @IBOutlet weak var coordinatesLbl: UILabel!
    @IBOutlet weak var imageUrlLbl: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var sectionNumberLbl: UILabel!
    
    @IBOutlet weak var postTimestampLbl: UILabel!
    
   
    @IBOutlet weak var imageLbl: UIImageView!
    
    @IBOutlet weak var latitudee: UILabel!
    
    
    @IBOutlet weak var longitudee: UILabel!
    
    
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

        if post.lat != nil {
            latitudee.text = "\(post.lat!)"
        } else {
            latitudee.text = "n/a lat"
        }
        
        if post.long != nil {
           longitudee.text = "\(post.long!)"
        } else {
            longitudee.text = "n/a long"
        }
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: post.lat, longitude: post.long)
        self.map.addAnnotation(annotation)
        let center = CLLocationCoordinate2D(latitude: post.lat, longitude: post.long)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
        self.map.setRegion(region, animated: true)

        //let coor = post.coordinatesGps
       // let latt = coor?.prefix(16)
        //let indexx = coor?.index(of: ",")
        //let long = coor?.suffix(from: indexx!).dropFirst()
       // let longg = String(describing: long?.dropFirst())
        
       // let lat = coor?.prefix(16)

        //let long = coor?.suffix(from: indexx!).dropFirst()
        //let doubleLong = Double(long)
        
       // let pinCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)

//        let annotation = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2D(latitude: Double("\(String(describing: latt))")!, longitude: Double("\(String(describing: long))")!)
//
    }

    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}











