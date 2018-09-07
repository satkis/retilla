//
//  MainMap.swift
//  retilla
//
//  Created by satkis on 2/12/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase


class MainMapVC: UIViewController {

    @IBOutlet weak var map: MKMapView!

    @IBOutlet weak var pullUpView: UIView!
    //@IBOutlet weak var reactionLbl: UILabel!
    //@IBOutlet weak var imageUrlLbl: UILabel!
    @IBOutlet weak var hashtagLbl: UILabel!
    @IBOutlet weak var sectionNrLbl: UILabel!
    @IBOutlet weak var sectionImg: UIImageView!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var imgLbl: UIImageView!
    @IBOutlet weak var postStoryLbl: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var totalPosts: UILabel!
    @IBOutlet weak var totalPostsText: UILabel!
    
    @IBOutlet weak var slideUpMenu: UIView!
    @IBOutlet weak var darkFillView: UIViewX!
    @IBOutlet weak var menuPopUpBttn: UIButton!
  
    var annot: Annotations?


    var annotationn = [Post]()

    var ref: DatabaseReference!
    
    var lat: CLLocationDegrees = 0.0
    var long: CLLocationDegrees = 0.0
    var timestamp: String! = "aaaa"
    var imageUrl: String? = "aaaa"
    var story: String? = "aaaa"
    var hashtag: String? = "aaaa"
    var reactions: Int? = 0

    let locationManager = CLLocationManager()
    let regionRadius: Double = 4500
    
    let authorizationStatus = CLLocationManager.authorizationStatus()
    
    let createPostVc = CreatingPostVC()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self

        hashtagLbl.isHidden = true
        sectionNrLbl.isHidden = true
        sectionImg.isHidden = true
        cityLbl.isHidden = true
        countryLbl.isHidden = true
        timeStampLbl.isHidden = true
        postStoryLbl.isHidden = true
        activityIndicator.isHidden = true
        imgLbl.isHidden = true
        categoryLbl.isHidden = true

        registerAnnotationViewClasses()
        fetchCoordinates()
        let minImg = UISwipeGestureRecognizer(target: self, action: #selector(MainMapVC.animateImgDown))
        minImg.direction = .down
        let minImgg = UISwipeGestureRecognizer(target: self, action: #selector(MainMapVC.animateImgDown))
        minImgg.direction = .up
        let minImggg = UISwipeGestureRecognizer(target: self, action: #selector(MainMapVC.animateImgDown))
        minImggg.direction = .left
        let minImgggg = UISwipeGestureRecognizer(target: self, action: #selector(MainMapVC.animateImgDown))
        minImgggg.direction = .right
        view.addGestureRecognizer(minImg)
        view.addGestureRecognizer(minImgg)
        view.addGestureRecognizer(minImggg)
        view.addGestureRecognizer(minImgggg)

        if CLLocationManager.locationServicesEnabled() {
            print("userLocationUPD_ViewDIdLoad_MainMapVC")
            locationManager.startUpdatingLocation()
            
        } else {
            locationManager.stopUpdatingLocation()
            print("not updating user location_MainMapVC")

        }

    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        locationManager.delegate = self
        configureLocationServices()

        
        self.map.addAnnotations(annotationn as! [MKAnnotation])
        activityIndicator.isHidden = true
        self.totalPosts.alpha = 0
        self.totalPostsText.alpha = 0
        
        showTotalPosts()
        
        ref = DataService.instance.URL_POSTS
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let totalPosts = snapshot.children.allObjects as? [DataSnapshot] {
                print("totalPosts:::", totalPosts.count)
                self.totalPosts.text = String(totalPosts.count)
            }
        }
    }


    
    func showTotalPosts() {
        if self.totalPosts.alpha == CGFloat(0) {
            
            UIView.animate(withDuration: 3) {
                self.totalPosts.alpha = 1
                self.totalPostsText.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 3) {
                self.totalPosts.alpha = 0
                self.totalPostsText.alpha = 0
            }
        }
    }
    

    
    func fetchCoordinates() {
        ref = DataService.instance.URL_BASE.child("posts")
        ref.observe(.value) { snapshot in
            
            for snap in snapshot.children {
                let postSnap = snap as! DataSnapshot
                if let dict = postSnap.value as? [String:AnyObject] {
                    let lat = dict["latitude"] as! CLLocationDegrees
                    let long = dict["longitude"] as! CLLocationDegrees
                    
                    let key = postSnap.key
                    let pinDetails = Post(postKey: key, dictionary: dict)
                    print("snap in MainMapVC:::: \(snap)")
                    let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))

                    self.map.setCenter(center, animated: true)
                    print("ffffff", self.map.setCenter(center, animated: true))
                    
                    let pinCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)

                    let aaaa = Annotations(coordinate: pinCoordinate, reactions: pinDetails.likes, imageUrl: pinDetails.imageUrl, postStory: pinDetails.postStory, hashtag: pinDetails.hashtag, sectionNumber: pinDetails.sectionNumber, location: pinDetails.location_city, countryLocation: pinDetails.location_country, timeStamp: pinDetails.timestamp, userName: pinDetails.username)
                    print("aaaa::: \(aaaa)")
 
                    aaaa.coordinate = pinCoordinate
                    
                    self.map.addAnnotation(aaaa)
                    
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        print(memberAnnotations)
        return MKClusterAnnotation(memberAnnotations: memberAnnotations)
    }

    func registerAnnotationViewClasses() {
        map.register(AnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        map.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    

    func menuSlider() {
        hashtagLbl.isHidden = false
        sectionNrLbl.isHidden = false
        sectionImg.isHidden = false
        cityLbl.isHidden = false
        countryLbl.isHidden = false
        timeStampLbl.isHidden = false
        postStoryLbl.isHidden = false
        //            activityIndicator.isHidden = false
        imgLbl.isHidden = false
        categoryLbl.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.darkFillView.transform = CGAffineTransform(scaleX: 20, y: 20)
            //                self.darkFillView.clipsToBounds = true
            self.slideUpMenu.clipsToBounds = true
            self.slideUpMenu.transform = CGAffineTransform(translationX: 0, y: -235)
            self.imgLbl.transform = CGAffineTransform(translationX: 120, y: 0)
            self.activityIndicator.transform = CGAffineTransform(translationX: 120, y: 0)
            self.menuPopUpBttn.transform = CGAffineTransform(rotationAngle: self.radians(degrees: 180))
        }) { (true) in
        }
    }
    

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Annotation selected")

   
        if let tappedPin = view.annotation as? Annotations {
            
            menuSlider()
            

            if let userNamee = tappedPin.userName {
                self.navigationItem.title = userNamee
            } else {
                self.navigationItem.title = " "
            }
            
            if let hashtag = tappedPin.hashtag {
                hashtagLbl?.text = hashtag
            } else {
                hashtagLbl?.text = "no hashtag"
            }

            if let sectionNr = tappedPin.sectionNumber {
                let img0 = UIImage(named: "circle0")
                let img1 = UIImage(named: "circle1")
                let img2 = UIImage(named: "circle2")
                let img3 = UIImage(named: "circle3")
                if sectionNr == 0 {
                    sectionNrLbl.text = "REUSE"
                    sectionImg.image = img0
                    
                } else if sectionNr == 1 {
                    sectionNrLbl.text = "RECYCLE"
                    sectionImg.image = img1
                } else if sectionNr == 2 {
                    sectionNrLbl.text = "REDUCE"
                    sectionImg.image = img2
                } else if sectionNr == 3 {
                    sectionNrLbl.text = "POLLUTION"
                    sectionImg.image = img3
                } else {
                    sectionNrLbl.text = "not found"
                    sectionImg.image = img3
                }
                
                
                
            }
            
            
            
            if let location = tappedPin.location {
                cityLbl?.text = location
            } else {
                cityLbl?.text = "no location"
            }
            
            if let countryLocation = tappedPin.countryLocation {
                countryLbl?.text = countryLocation
            } else {
                countryLbl?.text = "no country"
            }
            
            if (tappedPin.timeStamp) != nil {
                let timee = tappedPin.timeStamp
                let x = timee! / 1000
                let datee = Date(timeIntervalSince1970: x)
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                
                let finalTimeFormat = formatter.string(from: datee as Date)
                print("finalTime::", finalTimeFormat)
                timeStampLbl.text = finalTimeFormat
                
                } else {
                timeStampLbl.text = "no post time"
            }
            
            if let story = tappedPin.postStory {
                postStoryLbl.text = story
                print("poststorr:: \(postStoryLbl.text)")
            } else {
                postStoryLbl.text = "no story"
            }

           
            if let url = tappedPin.imageUrl {
                
                DispatchQueue.global().async {
                    print("loadinggg")
                    let url = URL(string: url)
                    let dataa = try? Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        self.imgLbl.image = UIImage(data: dataa!)
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                    }
                }
                print("loadeddd")
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
  
            }

        } else {

            sectionNrLbl.isHidden = true
            sectionImg.isHidden = true

            timeStampLbl.isHidden = true

            categoryLbl.isHidden = true
            
            UIView.animate(withDuration: 0.5, animations: {
                self.darkFillView.transform = .identity
                self.slideUpMenu.transform = .identity
                self.menuPopUpBttn.transform = .identity

                self.activityIndicator.transform = .identity
                self.imgLbl.transform = .identity

            }) { (true) in
            }

    }
    }

    
    @objc func animateImgDown() {

        UIView.animate(withDuration: 0.25) { () -> Void in
            self.imgLbl.frame = CGRect(x: 20, y: self.view.frame.height - self.slideUpMenu.frame.height - 70, width: 70, height: 70)

        }
    }

    

    @IBAction func imgTapped(_ sender: UITapGestureRecognizer) {

        UIView.animate(withDuration: 0.25) { () -> Void in

            self.imgLbl.frame = CGRect(x: 0, y: 120, width: self.view.frame.width, height: self.view.frame.height / 2)
            self.imgLbl.contentMode = .scaleAspectFit
        }
        
    }

    @IBAction func menuBttnTapped(_ sender: Any) {
        
        if darkFillView.transform == CGAffineTransform.identity {
            
            menuSlider()
        } else {
            sectionNrLbl.isHidden = true
            sectionImg.isHidden = true
            timeStampLbl.isHidden = true
            categoryLbl.isHidden = true
            
            UIView.animate(withDuration: 0.5, animations: {
                self.darkFillView.transform = .identity
                self.slideUpMenu.transform = .identity
                self.menuPopUpBttn.transform = .identity
                self.activityIndicator.transform = .identity
                self.imgLbl.transform = .identity
            }) { (true) in
            }
        }
    }
    
    func radians(degrees: Double) -> CGFloat {
        return CGFloat(degrees * .pi / degrees)
    }
    
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}

extension MainMapVC: CLLocationManagerDelegate {
    
    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            
        } else if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            print("allowedLocation_configureLocationServices_MainMapVC")
            if CLLocationManager.locationServicesEnabled() {
                print("start upd location_configureLocationServices_MainMapVC")
                locationManager.startUpdatingLocation()
                
            } else {
                
                print("nzn nzn nzn_configureLocationServices_MainMapVC")
                return
                
            }
        } else {
            print("returnreturnretrun_configureLocationServices_MainMapVC")
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        centerMapOnUserLocation()
        
        if status == .denied || status == .restricted {
            print("access declined")
        } else {
            print("nzn nzn nzn")
            return
        }
    }
    
}


extension MainMapVC: MKMapViewDelegate {
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }

}
