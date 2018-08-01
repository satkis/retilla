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


class MainMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    //@IBOutlet weak var pullUpViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pullUpView: UIView!
    
    //@IBOutlet weak var reactionLbl: UILabel!
    //@IBOutlet weak var imageUrlLbl: UILabel!
    @IBOutlet weak var hashtagLbl: UILabel!
    @IBOutlet weak var sectionNrLbl: UILabel!
    @IBOutlet weak var sectionImg: UIImageView!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
//    @IBOutlet weak var postStoryLbl: UILabel!
    @IBOutlet weak var imgLbl: UIImageView!
    @IBOutlet weak var postStoryLbl: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var totalPosts: UILabel!
    @IBOutlet weak var totalPostsText: UILabel!
    
    @IBOutlet weak var slideUpMenu: UIView!
    @IBOutlet weak var darkFillView: UIViewX!
    @IBOutlet weak var menuPopUpBttn: UIButton!
    
    
    
    
//    var reactions: Int?
//    var imageUrl: String!
//    var postStory: String?
//    var hashtag: String?
//    var sectionNumber: Int!
//    var location: String?
//    var timeStamp: String!
//

    
    //var geoFire: GeoFire!
    //var geoFireRef: DatabaseReference! - same like 'URL_GENERAL'
    
    var annot: Annotations?


    var annotationn = [Post]()
    // var pinDetails: Post?
    var ref: DatabaseReference!
    
    var lat: CLLocationDegrees = 0.0
    var long: CLLocationDegrees = 0.0
    var timestamp: String! = "aaaa"
    var imageUrl: String? = "aaaa"
    var story: String? = "aaaa"
    var hashtag: String? = "aaaa"
    var reactions: Int? = 0
    
    //    var annotationnn: Annotations?
    //    var titleeee: String? = "klkl"
    //    var hashh: String?
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 9500
    
    //these will need to be downloaded from Firebase and here should be coordinates
    //    let addresses = [
    //
    //    "Ozo g. 14, Vilnius 08200",
    //    "Verkių g. 29, Vilnius 09108",
    //    "Bow Bridge, New York, NY 10024, Jungtinės Valstijos"
    //    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        //self.view.addSubview(DetailPinView)
        locationAuthStatus()
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
        //imgVisibility()
        

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

       // imgLbl.center = CGPoint(x: -100, y: 522)
        //geoFire = GeoFire(firebaseRef: URL_GENERAL)
        
        // reactionLbl.text = annotationnnnn?.hashtag
        // print("reactionLBL.text in viewdidLoad: \(reactionLbl.text)")
  

    }
    
    //        for add in addresses {
    //            getPlaceMarkFromAddress(address: add)
    //        }
    
    
    override func viewDidAppear(_ animated: Bool) {
        fetchCoordinates()
        registerAnnotationViewClasses()
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
    
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            map.showsUserLocation = false
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            centerMapOnLocation(location: loc)
            print("location loc: \(loc)")
            let lat = loc.coordinate.latitude
            let long = loc.coordinate.longitude
            print(lat, long)
            
        }
    }
    
    
    
    //    func createAnnotationforLocation(location: CLLocation) {
    //        let anot = Annotations(coordinate: location.coordinate, identifier: "droppablePin")
    //        map.addAnnotation(anot)
    //    }
    
    //    func getPlaceMarkFromAddress(address: String) {
    //        CLGeocoder().geocodeAddressString(address) { (placemark, error) in
    //            if let marks = placemark, marks.count > 0 {
    //                if let loc = marks[0].location {
    //                    //we have a valid location with coordinates
    //                    self.createAnnotationforLocation(location: loc)
    //                }
    //            }
    //        }
    //    }
    
    
    
    func fetchCoordinates() {
        //URL_BASE.child("users").child(uid!).child("reactions").child(post.postKey)
        ref = DataService.instance.URL_BASE.child("posts")
        ref.observe(.value) { snapshot in
            
            for snap in snapshot.children {
                let postSnap = snap as! DataSnapshot
                if let dict = postSnap.value as? [String:AnyObject] {
                    let lat = dict["latitude"] as! CLLocationDegrees
                    let long = dict["longitude"] as! CLLocationDegrees
                    
                    let key = postSnap.key
                    let pinDetails = Post(postKey: key, dictionary: dict)
//                    let pinDetailsTimestamp = String(pinDetails.timestamp)
                    
                    //                    var titlee = dict["location"] as! String
//                                        var timestampp = dict["timestamp"] as! String
                    //                    var reactions = dict["reactions"] as? String
                    //                    var location = dict["location"] as! String
                    //                    var imageUrl = dict["imageUrl"] as! String
                    //                    var story = dict["description"] as? String
                    // var hashtag = dict["hashtag"] as? String
                    print("snap in MainMapVC:::: \(snap)")
                    let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
                    
                    self.map.setRegion(region, animated: true)
                    
                    let pinCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
                    
                    //                    let annot = Annotations(
                    //                        coordinate: pinCoordinate,
                    //                        reactions: pinDetails.likes,
                    //                        imageUrl: pinDetails.imageUrl,
                    //                        postStory: pinDetails.postStory,
                    //                        hashtag: pinDetails.hashtag,
                    //                        sectionNumber: pinDetails.sectionNumber,
                    //                        location: pinDetails.location,
                    //                        timeStamp: pinDetails.timestamp
                    //                    )
                    
                    let aaaa = Annotations(coordinate: pinCoordinate, reactions: pinDetails.likes, imageUrl: pinDetails.imageUrl, postStory: pinDetails.postStory, hashtag: pinDetails.hashtag, sectionNumber: pinDetails.sectionNumber, location: pinDetails.location_city, countryLocation: pinDetails.location_country, timeStamp: pinDetails.timestamp, userName: pinDetails.username)
                    print("aaaa::: \(aaaa)")
                    //                    self.titleeee = annotationnnnn.hashtag
                    // print("self.Titleeee::: \(String(describing: self.titleeee))")
                    
                    //                    self.reactionLbl.text = self.titleeee
                    //                    print("reactionLbl.text::: \(String(describing: self.reactionLbl.text))")
                    
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
//
//    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
//        let test = MKClusterAnnotation(memberAnnotations: memberAnnotations)
//        test.title = "Emojis"
//        test.subtitle = nil
//        return test
//    }
//
    


    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKUserLocation {
//            return nil
//        } else {
//            if let annotation = annotation as? Annotations {
//                var view: MKPinAnnotationView
//                let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
//                dequeuedView?.annotation = annotation
//
//                if annotation.sectionNumber == 0 {
//
////                    dequeuedView?.annotation = annotation
//                    view = dequeuedView!
//                    view.canShowCallout = false
//                    view.pinTintColor = .blue
//                } else if annotation.sectionNumber == 1 {
////                    let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
////                    dequeuedView?.annotation = annotation
//                    view = dequeuedView!
//                    view.canShowCallout = false
//                    view.pinTintColor = .blue
//                } else if annotation.sectionNumber == 2{
////                    let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
////                    dequeuedView?.annotation = annotation
//                    view = dequeuedView!
//                    view.canShowCallout = false
//                    view.pinTintColor = .red
////                } else if annotation.sectionNumber == 3, annotation != nil {
//////                    let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
//////                    dequeuedView?.annotation = annotation
////                    view = dequeuedView!
////                    view.canShowCallout = false
////                    view.pinTintColor = .yellow
//                }
//                    return dequeuedView
//
//            }
//            return nil
//        }
//    }

    
    
    func registerAnnotationViewClasses() {
        map.register(AnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        map.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKUserLocation {
//            //nill to not make user location as a pin
//            return nil
//        } else {
//            if let annotation = annotation as? Annotations {
//                var view: MKPinAnnotationView
//                if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView {
//                    dequeuedView.annotation = annotation
//                    view = dequeuedView
//                    view.canShowCallout = false
//                    view.clusteringIdentifier = "identifier"
//
////                    view.pinTintColor = annotation.markerTintColorr
//
//                } else {
//                    view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
//
//                    view.canShowCallout = false
//                    view.clusteringIdentifier = "identifier"
//
////                    view.pinTintColor = annotation.markerTintColorr
//
//                    //view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
//
//                }
//                return view
//            }
//            return nil
//        }
//    }
    
  
    
    //    func updatePulledUpView() {
    //        let labelll = view.annotation
    //
    //         print("c\(String(describing: labelll))")
    //        print("updatePulledUpView:::")
    //        if labelll != "" {
    //            self.reactionLbl.text = labelll
    //            print("hashh in func: \(String(describing: labelll))")
    //        } else {
    //            self.reactionLbl.text = "noo dataa"
    //        }
    //        reloadInputViews()
    //    }
    
    
    
    //    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //        if annotation is MKUserLocation {
    //            //nill to not make user location as a pin
    //            return nil
    //        } else {
    //        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
    //        pinAnnotation.pinTintColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
    //        pinAnnotation.animatesDrop = true
    //        return pinAnnotation
    //        }
    //    }
    
    
    
    
    
    //    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    //        print("call out accessory Control Tapped::: \(annotationn)")
    //    }

    
//    func addSwipe() {
//        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateViewDown))
//
//        swipe.direction = .down
//        pullUpView.addGestureRecognizer(swipe)
//        //        let tap = UITapGestureRecognizer(target: self, action: #selector(animateViewDown))
//        //        swipe.direction = .down
//        //        view.addGestureRecognizer(tap)
//    }
    
//    func animateViewUp() {
////        pullUpViewHeightConstraint.constant = 150
//
//        UIView.animate(withDuration: 0.3) {
//            self.view.setNeedsLayout()
//            self.view.layoutIfNeeded()
//        }
////
////        UIImageView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 30, animations: ({
////            self.imgLbl.center = CGPoint(x: 16, y: 522)
////        }), completion: nil)
//    }
    
    
    
//    @objc func animateViewDown() {
////        pullUpViewHeightConstraint.constant = 0
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//            self.imgLbl.isHidden = true
//
//
//        }
//
//    }
    
    
//   func addSwipeUp() {
//        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(animateViewUpUpUp))
//        swipeUp.direction = .up
//
//        pullUpView.addGestureRecognizer(swipeUp)
//    }


    
 
//    @objc func animateViewUpUpUp() {
//
////        pullUpViewHeightConstraint.constant = 250
//    }
    
    
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

        
       // menuBttnTapped(MKAnnotationView.self)
        //menuBttnTapped(mapView)
//          self.slideUpMenu.transform = CGAffineTransform(translationX: 0, y: -235)
        
        if let tappedPin = view.annotation as? Annotations {
            
            menuSlider()
            
//            menuBttnTapped(tappedPin)

//            self.imgLbl.layer.cornerRadius = 8.0
//            if let reactions = tappedPin.reactions {
//                reactionLbl?.text = "\(reactions)"
//            } else {
//                reactionLbl?.text = "no reactions"
//            }
//            
//            if let imageUrl = tappedPin.imageUrl {
//                imageUrlLbl.text = imageUrl
//            } else {
//                imageUrlLbl.text = "no url"
//            }
            
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
            
//            if let sectionNr = tappedPin.sectionNumber {
//                sectionNrLbl.text = "\(sectionNr)"
//            } else {
//                sectionNrLbl.text = "no sectionNr"
//            }
            
            if let sectionNr = tappedPin.sectionNumber {
//                let img0 = UIImageView(named: #imageLiteral(resourceName: "circle0"))
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
            
            //             NEED TO adjust if image fails to download (make default value)
            //NEED TO cache img. Plus, NEED TO make new .swift file for UIView and place all view details there
           
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
                //self.imgLbl.isHidden = true
                //self.imgLbl.layer.cornerRadius = 8.0
                
            }
//                let data = try? Data(contentsOf: url!)
//
//                imgLbl.image = UIImage(data: data!)
       
//
//                //                var image: UIImage?
//                //                print("url::: \(url)")
//                //                image = MainMapVC.imageCach.object(forKey: url as AnyObject) as? UIImage
//                //                imgLbl.image = image
//                //                print("imgLbl.image \(String(describing: imgLbl.image))")
//                //            } else {
//                //                imgLbl.image = UIImage(named: "Unknown")
//                //            }
//
//
//
//
//                //        let hashtag = view.annotation?.title
//                //        print("hashtag::: \(String(describing: hashtag))")
//                //        if let hashtag = view.annotation?.title {
//                //            reactionLbl.text = hashtag
//                //        } else {
//                //         reactionLbl.text = "no hashtag"
//                //        }
//                //
//                //        let timeee = annotationnn?.timeStampp
//                //        print("timeee::: \(String(describing: timeee))")
//                //
//
//            }
            
            
            //        if let detailAnnotView = Bundle.main.loadNibNamed("DetailAnnotationView", owner: self, options: nil)?.first as? DetailAnnotationView {
            //            let pinToZoon = view.annotation?.title
            //            detailAnnotView.xibLabel.text = pinToZoon!
            //            self.view.addSubview(detailAnnotView)
            //
            ////            detailAnnotView.setNeedsLayout()
            ////            detailAnnotView.layoutIfNeeded()
            //
            //        }
            
            
            
            
            
            // self.selectedAnnotaton = view.annotation as? Annotations
            
            //        let anno = annotationn[index(ofAccessibilityElement: selectedAnnotaton!)]
            //        print("annnnnnooo::: \(anno)")
            
            //animateViewUpUp()
            //        updatePulledUpView()
            
//            animateViewUp()

//            addSwipe()


//                addSwipeUp()
     

            //        if case self.selectedAnnotaton = view.annotation as? Annotations {
            //            print("selected annotation coordinate::: \(String(describing: self.selectedAnnotaton))")
            //
            //
            //        }
            
            
            
            //        animateViewUp()
            //        addSwipe()
        } else {
            imgLbl.isHidden = true
            activityIndicator.isHidden = false
        }
        
//            activityIndicator.isHidden = false
//            activityIndicator.startAnimating()
        
        
    }

    
    @objc func animateImgDown() {
        //self.imageLbl.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)

        UIView.animate(withDuration: 0.25) { () -> Void in
            self.imgLbl.frame = CGRect(x: 20, y: 368, width: 70, height: 70)
//            self.imgLbl.layer.cornerRadius = 8.0
//            self.imgLbl.transform = .identity
//            self.activityIndicator.transform = .identity
        }
    }

    

    @IBAction func imgTapped(_ sender: UITapGestureRecognizer) {

//     self.slideUpMenu.clipsToBounds = false
//        self.imgLbl.superview?.bringSubview(toFront: imgLbl)
//        self.imgLbl.layer.masksToBounds = false
//        self.imgLbl.transform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
        //self.imgLbl.alpha = 0
        
        UIView.animate(withDuration: 0.25) { () -> Void in
//            self.imgLbl.alpha = 1
            let xx = self.view.frame.width / 2 - 290/2
            let yy = self.view.frame.height / 2 - 300
            self.imgLbl.center = self.view.center
            self.imgLbl.frame = CGRect(x: xx, y: yy, width: 290, height: 350)
            self.imgLbl.contentMode = .scaleAspectFit
//            self.imgLbl.layer.cornerRadius = 8.0
        }
        
    }

//    func imgVisibility() {
//        if self.slideUpMenu.transform == CGAffineTransform(translationX: 0, y: -235) {
//            self.imgLbl.isHidden = false
//        } else {
//            self.imgLbl.isHidden = true
//        }
//    }
//
    
    @IBAction func menuBttnTapped(_ sender: Any) {
       // if self.annot?.sectionNumber != nil {
        
        if darkFillView.transform == CGAffineTransform.identity {
            
            menuSlider()
        } else {
//            hashtagLbl.isHidden = true
            sectionNrLbl.isHidden = true
            sectionImg.isHidden = true
//            cityLbl.isHidden = true
//            countryLbl.isHidden = true
            timeStampLbl.isHidden = true
//            postStoryLbl.isHidden = true
//            activityIndicator.isHidden = true
//            imgLbl.isHidden = true
            categoryLbl.isHidden = true
            
            UIView.animate(withDuration: 0.5, animations: {
                self.darkFillView.transform = .identity
                self.slideUpMenu.transform = .identity
                self.menuPopUpBttn.transform = .identity
//                self.imgLbl.transform = CGAffineTransform(translationX: -120, y: 0)
//                self.activityIndicator.transform = CGAffineTransform(translationX: -120, y: 0)
//                self.imgAway()
                self.activityIndicator.transform = .identity
                self.imgLbl.transform = .identity
                //self.imgLbl.isHidden = true
                //self.activityIndicator.isHidden = false
            }) { (true) in
            }
        }
    }
    
    func radians(degrees: Double) -> CGFloat {
        return CGFloat(degrees * .pi / degrees)
    }
    
    
    
    
    
    
    
    
    
    //
    //        //observe single event - it checks only ONCE in Firebase if theres any reactions/likes by user.
    //        reactionRef.observeSingleEvent(of: .value, with: { snapshot in
    //
    //            //in Firebase if there's no data, then it's NSNULL. nil won't work
    //            if let doesNotExist = snapshot.value as? NSNull {
    //                //this means user hasn't liked this specific post
    //                self.reactionImg.image = UIImage(named: "heartEmpty")
    //
    //            } else {
    //                self.reactionImg.image = UIImage(named: "heartFull")
    //            }
    //        })
    //    }
    //
    //
    //        DataService.instance.URL_POSTS.observeSingleEvent(of: .value) { (snapshot) in
    //            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
    //                for snap in snapshots {
    //                    print("SNAP IN MAPVC \(snap)")
    //
    //                    if let postDisctionary = snap.value as? Dictionary<String, AnyObject> {
    //                        let lattt = self.post.lat
    //                        let longgg = self.post.long
    ////                        let key = snap.key
    ////                        let post = Post(postKey: key, Dictionary: postDisctionary)
    ////                        let lat =
    ////
    ////                        let lat = post.
    //                }
    ////            }
    //        }
    //    }
    //
    //
    //
    //
    //
    //
    //
    //    DataService.instance.URL_POSTS.observe(.value) { (snapshot) in
    //    print(snapshot.value as Any)
    //    self.posts = []
    //
    //    //this gives us data individual (every post separate array/dict?)
    //    //snapshot is like "posts" or "users" in Firebase, and snap is "likes", "hashtag" etc
    //    if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
    //    for snap in snapshots {
    //    print("SNAP::: \(snap)")
    //
    //    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
    //    //key is user/post ID
    //    let key = snap.key
    //    let post = Post(postKey: key, dictionary: postDictionary)
    //
    //    var section = post.sectionNumber?.hashValue
    //    print("SECTIONN: \(String(describing: section))")
    //
    //    self.posts.insert(post, at: 0)
    //
    //    }
    //    }
    //    }
    //
    //    self.tableView.reloadData()
    //    }
    //    print("ViewDidLoad Ended")
    //}
    //
    //
    //
    //
    
    
    
    
    
    
    
}
