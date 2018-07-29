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
    var postInUserVCC: postInUserVC!
    var user: User!
    var lat: CLLocationDegrees = 0.0
    var long: CLLocationDegrees = 0.0
    var effect: UIVisualEffect!
    
    var userName: String?
    var postStoryy: String?
    var hashtagg: String?
    var sectionNumberr: Int?
    var cityy: String?
    var countryy: String?
    var postTimeStampp: Double?
    var imagee: String?
    var latt: Double?
    var longg: Double?
    
    @IBOutlet weak var blurrView: UIVisualEffectView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    //let regionRadius: CLLocationDistance = 1000
    
    //@IBOutlet weak var postStoryLbl: UILabel!
    
    @IBOutlet weak var postStoryLbl: UITextView!
    
    
    @IBOutlet weak var hashtagLbl: UILabel!
    
    @IBOutlet weak var imgCategory: UIImageView!
    

    //@IBOutlet weak var likesLbl: UILabel!
    
//    @IBOutlet weak var usernameLbl: UILabel!
    
    @IBOutlet weak var sectionNumberLbl: UILabel!
   
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    
    @IBOutlet weak var postTimestampLbl: UILabel!
    
   
    @IBOutlet weak var imageLbl: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        
        imageLbl.layer.cornerRadius = 8.0
        print("POSTDETAILVCC countryy:::", countryy)
        //imageLbl.clipsToBounds = true
//        imageLbl.contentMode = .scaleAspectFill
       //imageLbl.layer.shadowColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        //imageLbl.layer.shadowOpacity = 0.2
        //effect = visualEffectView.effect
        
        
//        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.hidesBarsOnSwipe = false
//        self.navigationController.

        
//        if self.trtrtr != nil {
//            print("POSTDETAILVCC self.trtrtr:::", self.trtrtr)
//
//            self.title = self.trtrtr
//        } else {
//            self.title = post.usernames
//        }
        
        if let userNm = self.userName {
            self.title = userNm
            print("userNm", userNm)
        } else if let userNmm = post.username {
            self.title = userNmm
        } else {
            self.title = "noo"
        }
        
//        imageLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PostDetailVCC.animate)))
//        view.addSubview(imageLbl)
        
//        let maximizeImg = UITapGestureRecognizer(target: imageLbl, action: #selector(PostDetailVCC.animate))
////        tap.numberOfTapsRequired = 3
//        view.addGestureRecognizer(maximizeImg)
//        view.addSubview(imageLbl)
        
        
//        imageLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PostDetailVCC.animateViewDown)))
      let minimizeImg = UISwipeGestureRecognizer(target: self, action: #selector(PostDetailVCC.animateViewDown))
        minimizeImg.direction = .down
        let minimizeImgg = UISwipeGestureRecognizer(target: self, action: #selector(PostDetailVCC.animateViewDown))
        minimizeImgg.direction = .left
        let minimizeImggg = UISwipeGestureRecognizer(target: self, action: #selector(PostDetailVCC.animateViewDown))
        minimizeImggg.direction = .right
        let minimizeImgggg = UISwipeGestureRecognizer(target: self, action: #selector(PostDetailVCC.animateViewDown))
        minimizeImgggg.direction = .up
        view.addGestureRecognizer(minimizeImg)
        view.addGestureRecognizer(minimizeImgg)
        view.addGestureRecognizer(minimizeImggg)
        view.addGestureRecognizer(minimizeImgggg)
    

//        imageLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PostDetailVCC.animateOut)))
//        view.removeFromSuperview()

//        if let locCity = postInUserVCC.sectionNo {
//            cityLbl.text = "\(locCity)"
//            print("locCity:::", locCity)
//        } else if let locCit = post.location_city {
//            cityLbl.text = "\(locCit)"
//        } else {
//            cityLbl.text = "no valuee::"
//        }
        
        
//        if let userNm = self.userName {
//            self.title = userNm
//            print("userNm", userNm)
//        } else if let userNmm = post.username {
//            self.title = userNmm
//        } else {
//            self.title = "noo"
//        }
        
        if let cityFromUserVC = self.cityy {
            cityLbl.text = cityFromUserVC
        } else if let cityFromFeedVC = post.location_city {
            cityLbl.text = cityFromFeedVC
        } else {
            cityLbl.text = "n/a"
        }
        
        if let countryFromUserVC = self.countryy {
            countryLbl.text = countryFromUserVC
        } else if let countryFromFeedVC = post.location_country {
            countryLbl.text = countryFromFeedVC
        } else {
            countryLbl.text = "n/a"
        }

        
        if let storyFromUserVC = self.postStoryy {
            postStoryLbl.text = storyFromUserVC
        } else if let storyFromFeedVC = post.postStory {
            postStoryLbl.text = storyFromFeedVC
        } else {
            postStoryLbl.text = "No story"
        }
        
        
        if let sectionNRFromUserVC = self.sectionNumberr {
            sectionNumberLbl.text = "\(sectionNRFromUserVC)"
        } else if let sectionNRFromFeedVC = post.sectionNumber {
            sectionNumberLbl.text = "\(sectionNRFromFeedVC)"
        } else {
            sectionNumberLbl.text = "n/a"
        }

        
        if let hashtagFromUserVC = self.hashtagg {
            hashtagLbl.text = hashtagFromUserVC
        } else if let hashtagFromFeedFC = post.hashtag {
            hashtagLbl.text = hashtagFromFeedFC
        } else {
            hashtagLbl.text = "NO hashtag found"
        }

        if let sectionNr = sectionNumberLbl.text {
            //                let img0 = UIImageView(named: #imageLiteral(resourceName: "circle0"))
            let img0 = UIImage(named: "circle0")
            let img1 = UIImage(named: "circle1")
            let img2 = UIImage(named: "circle2")
            let img3 = UIImage(named: "circle3")
            if sectionNr == "\(0)" {
                sectionNumberLbl.text = "REUSE"
                imgCategory.image = img0
                
            } else if sectionNr == "\(1)" {
                sectionNumberLbl.text = "RECYCLE"
                imgCategory.image = img1
            } else if sectionNr == "\(2)" {
                sectionNumberLbl.text = "REDUCE"
                imgCategory.image = img2
            } else if sectionNr == "\(3)" {
                sectionNumberLbl.text = "POLLUTION"
                imgCategory.image = img3
            } else {
                sectionNumberLbl.text = "not found"
                imgCategory.image = img3
            }
            
            
            
        }
        

        //self.likesLbl.text = "\(post.likes!)"
        
//        if let likes = post.likes, post.likes != nil {
//            likesLbl.text = String(likes)
//        } else {
//            likesLbl.text = "n/a likes"
//        }
        
//        if post.username != nil {
//            usernameLbl.text = post.username
//        } else {
//            usernameLbl.text = "n/a username"
//        }
 
        
        
        
        
        if self.postTimeStampp != nil {
            let time = self.postTimeStampp
            let x = time! / 1000
            let datee = Date(timeIntervalSince1970: x)
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            
            let finalTimeFormat = formatter.string(from: datee as Date)
            print("finalTimefromUserVC::", finalTimeFormat)
            postTimestampLbl.text = finalTimeFormat
        } else if post.timestamp != nil {
            let timee = post.timestamp
            let x = timee! / 1000
            let datee = Date(timeIntervalSince1970: x)
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            
            let finalTimeFormat = formatter.string(from: datee as Date)
            print("finalTimeFromFeedVC::", finalTimeFormat)
            
            postTimestampLbl.text = finalTimeFormat
        } else {
            postTimestampLbl.text = "post time n/a"
        }

//        if post.timestamp != nil {
//
//             postTimestampLbl.text = "\(post.timestamp)"
//            let converted = NSDate(timeIntervalSince1970: post.timestamp / 1000)
            
            
            //ERROR HERE
//            let converted = Date(timeIntervalSince1970: Int(post.timestamp)! / 1000)
//            print("converted \(converted)")
            
//
//            let dateFormatter = DateFormatter()
//            dateFormatter.timeZone = NSTimeZone.local
//            dateFormatter.dateFormat = "hh:mm a"
//            let time = dateFormatter.string(from: converted)
//            print("timee \(time)")
           
            
            
//             postTimestampLbl.text = "\(post.timestamp!.prefix(6))"
//        } else {
//            postTimestampLbl.text = "n/a time"
//        }

        // NEED TO adjust if image fails to download (make default value)
        
        if let imgFromUserVC = self.imagee {
            let cacheImage = FeedVCC.imageCache.object(forKey: imgFromUserVC as AnyObject) as? UIImage
            imageLbl.image = cacheImage
        } else if let imgFromFeedVC = post.imageUrl {
            let cacheImg = FeedVCC.imageCache.object(forKey: imgFromFeedVC as AnyObject) as? UIImage
            imageLbl.image = cacheImg
        } else {
            return
        }

        
        if let latLongFromUserVC = self.latt {
            annotation.coordinate = CLLocationCoordinate2D(latitude: self.latt!, longitude: self.longg!)
            self.map.addAnnotation(annotation)
            let center = CLLocationCoordinate2D(latitude: self.latt!, longitude: self.longg!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
            self.map.setRegion(region, animated: true)
        } else {
        annotation.coordinate = CLLocationCoordinate2D(latitude: post.lat, longitude: post.long)
        self.map.addAnnotation(annotation)
        let center = CLLocationCoordinate2D(latitude: post.lat, longitude: post.long)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
        self.map.setRegion(region, animated: true)
        }
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
    
//    @objc func animate() {
//
//        self.imageLbl.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
////        self.imageLbl.alpha = 0
//
//        UIView.animate(withDuration: 0.25) { () -> Void in
////            let xx = self.view.frame.width
////            let yy = self.view.frame.height
//            self.visualEffectView.effect = self.effect
//            self.imageLbl.alpha = 1
////            self.imageLbl.transform = CGAffineTransform.identity
//            self.imageLbl.frame = CGRect(x: 0, y: 150, width: 375, height: 500)
////            self.blurrView.effect = self.effect
//            self.imageLbl.contentMode = .scaleAspectFit
//            //self.imageLbl.backgroundColor = UIColor.black
//            self.imageLbl.layer.cornerRadius = 8.0
//
//        }
//    }
//
//    func addSwipe() {
//        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateViewDown))
//
//        swipe.direction = .down
//        imageLbl.addGestureRecognizer(swipe)
//    }
    
    @objc func animateViewDown() {
//self.imageLbl.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
        UIView.animate(withDuration: 0.25) { () -> Void in
            self.imageLbl.frame = CGRect(x: 12, y: 196, width: 77, height: 77)
        }
    }
    
    
    
//    @objc func animateOut() {
//
//        UIView.animate(withDuration: 0.25) {
//            self.imageLbl.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
//            self.imageLbl.alpha = 0
//            self.visualEffectView.effect = nil
//            }
//                self.imageLbl.removeFromSuperview()
//        }
//
    
    
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
    
    
    @IBAction func imgTapped(_ sender: UITapGestureRecognizer) {
        
        //     self.slideUpMenu.clipsToBounds = false
        //        self.imgLbl.superview?.bringSubview(toFront: imgLbl)
        //        self.imgLbl.layer.masksToBounds = false
        //        self.imgLbl.transform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
        //self.imgLbl.alpha = 0
        
        UIView.animate(withDuration: 0.25) { () -> Void in
            //            self.imgLbl.alpha = 1
            self.imageLbl.frame = CGRect(x: 0, y: 150, width: 375, height: 450)
            self.imageLbl.contentMode = .scaleAspectFit
            //            self.imgLbl.layer.cornerRadius = 8.0
        }
        
    }
    
}











