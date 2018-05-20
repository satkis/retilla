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
    var user: User!
    var lat: CLLocationDegrees = 0.0
    var long: CLLocationDegrees = 0.0
    var effect: UIVisualEffect!
    
    @IBOutlet weak var blurrView: UIVisualEffectView!
    @IBOutlet weak var map: MKMapView!
    //let regionRadius: CLLocationDistance = 1000
    
    @IBOutlet weak var postStoryLbl: UILabel!
    @IBOutlet weak var hashtagLbl: UILabel!


    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var sectionNumberLbl: UILabel!
   
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    
    @IBOutlet weak var postTimestampLbl: UILabel!
    
   
    @IBOutlet weak var imageLbl: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        
        effect = blurrView.effect
        blurrView.effect = nil
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.title = "some"
        
        imageLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PostDetailVCC.animate)))
        view.addSubview(imageLbl)
        

//        imageLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PostDetailVCC.animateOut)))

        
        if post.location_city != nil {
            cityLbl.text = post.location_city
        } else {
            cityLbl.text = "City unidentified"
        }
        
        if post.location_country != nil {
            countryLbl.text = post.location_country
        } else {
            countryLbl.text = "City unidentified"
        }
        
        if post.postStory != nil {
            postStoryLbl.text = post.postStory
        } else {
            postStoryLbl.text = "NO story found"
        }
        
        if post.sectionNumber != nil {
            sectionNumberLbl.text = "\(post.sectionNumber!)"
        } else {
            sectionNumberLbl.text = "n/a"
        }
  
        if post.hashtag != nil {
            hashtagLbl.text = post.hashtag
        } else {
            hashtagLbl.text = "NO hashtag found"
        }
        

        self.likesLbl.text = "\(post.likes!)"
        
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
            postTimestampLbl.text = "\(post.timestamp)"
//             postTimestampLbl.text = "\(post.timestamp!.prefix(6))"
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
    
    @objc func animate() {
        
        self.imageLbl.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        self.imageLbl.alpha = 0
        
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.imageLbl.frame = CGRect(x: (self.view.frame.width / 2) - 120, y: (self.view.frame.height / 2) - 150, width: 240, height: 300)
            self.blurrView.effect = self.effect
            self.imageLbl.alpha = 1
            self.imageLbl.transform = CGAffineTransform.identity
            self.imageLbl.layer.cornerRadius = 5
            
            
        }
    }
    
//    @objc func animateOut() {
//
//        if let startingFrame = imageLbl.superview?.convert(imageLbl.frame, to: nil) {
//            UIView.animate(withDuration: 0.75, animations: { () -> Void in
//                self.imageLbl.frame = startingFrame
//            }, completion: { (didComplete) -> Void in
//                self.imageLbl.removeFromSuperview()
//                self.blurrView.effect = nil
//            }
//        )}
//        UIView.animate(withDuration: 0.25, animations: {
//            self.imageLbl.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
//            self.imageLbl.alpha = 0
//
//            self.blurrView.effect = nil
//        }) { (success: Bool) in
//            self.imageLbl.removeFromSuperview()
//        }
//    }


    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}











