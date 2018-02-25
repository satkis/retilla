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
import GeoFire

class MainMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var pullUpViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pullUpView: UIView!
    
    @IBOutlet weak var reactionLbl: UILabel!
    @IBOutlet weak var imageUrlLbl: UILabel!
    @IBOutlet weak var hashtagLbl: UILabel!
    @IBOutlet weak var sectionNrLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var postStoryLbl: UILabel!
    
    
    
//    var reactions: Int?
//    var imageUrl: String!
//    var postStory: String?
//    var hashtag: String?
//    var sectionNumber: Int!
//    var location: String?
//    var timeStamp: String!
//
    
    
    
    var geoFire: GeoFire!
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
    let regionRadius: CLLocationDistance = 10000
    
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
   
        geoFire = GeoFire(firebaseRef: URL_GENERAL)

       // reactionLbl.text = annotationnnnn?.hashtag
       // print("reactionLBL.text in viewdidLoad: \(reactionLbl.text)")
        
      
        
        
        }
        
//        for add in addresses {
//            getPlaceMarkFromAddress(address: add)
//        }
    

    override func viewDidAppear(_ animated: Bool) {
        fetchCoordinates()
        
        self.map.addAnnotations(annotationn as! [MKAnnotation])

    }


    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            map.showsUserLocation = true
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
                    
//                    var titlee = dict["location"] as! String
//                    var timestamp = dict["timestamp"] as! String
//                    var reactions = dict["reactions"] as? String
//                    var location = dict["location"] as! String
//                    var imageUrl = dict["imageUrl"] as! String
                    //                    var story = dict["description"] as? String
                    // var hashtag = dict["hashtag"] as? String
                    print("snap in MainMapVC:::: \(snap)")
                    let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08))
                    
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
                    
                    let aaaa = Annotations(coordinate: pinCoordinate, reactions: pinDetails.likes, imageUrl: pinDetails.imageUrl, postStory: pinDetails.postStory, hashtag: pinDetails.hashtag, sectionNumber: pinDetails.sectionNumber, location: pinDetails.location, timeStamp: pinDetails.timestamp)
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
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //nill to not make user location as a pin
            return nil
        } else {
            if let annotation = annotation as? Annotations {
                let identifier = "pin"
                var view: MKPinAnnotationView
                if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
                } else {
                    view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    view.canShowCallout = true
                    view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView

                    
                }
                return view
            }
            return nil
    }
}
    
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
    
    
    func addSwipe() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateViewDown))
        swipe.direction = .down
        pullUpView.addGestureRecognizer(swipe)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(animateViewDown))
//        swipe.direction = .down
//        view.addGestureRecognizer(tap)
    }

    func animateViewUp() {
        pullUpViewHeightConstraint.constant = 200
        UIView.animate(withDuration: 0.3) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            
            
            
        }
    }
    
    @objc func animateViewDown() {
        pullUpViewHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Annotation selected")
        
        if let tappedPin = view.annotation as? Annotations {
            if let reactions = tappedPin.reactions {
                reactionLbl?.text = "\(reactions)"
            } else {
                reactionLbl?.text = "no reactions"
            }
            
            if let imageUrl = tappedPin.imageUrl {
                imageUrlLbl.text = imageUrl
            } else {
                imageUrlLbl.text = "no url"
            }
            
            if let hashtag = tappedPin.hashtag {
                hashtagLbl?.text = hashtag
            } else {
                hashtagLbl?.text = "no hashtag"
            }
            
            if let sectionNr = tappedPin.sectionNumber {
                sectionNrLbl.text = "\(sectionNr)"
            } else {
                sectionNrLbl.text = "no sectionNr"
            }
            
            if let location = tappedPin.location {
                locationLbl?.text = location
            } else {
                locationLbl?.text = "no location"
            }
            
            if let time = tappedPin.timeStamp {
                timeStampLbl.text = time
            } else {
                timeStampLbl.text = "no post time"
            }
            
            if let story = tappedPin.postStory {
                postStoryLbl?.text = story
            } else {
                postStoryLbl?.text = "no story"
            }
 
//        let hashtag = view.annotation?.title
//        print("hashtag::: \(String(describing: hashtag))")
//        if let hashtag = view.annotation?.title {
//            reactionLbl.text = hashtag
//        } else {
//         reactionLbl.text = "no hashtag"
//        }
//
//        let timeee = annotationnn?.timeStampp
//        print("timeee::: \(String(describing: timeee))")
//
            
        }

        
        
        
        
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
       
        animateViewUp()
//        updatePulledUpView()
        addSwipe()

        
//        if case self.selectedAnnotaton = view.annotation as? Annotations {
//            print("selected annotation coordinate::: \(String(describing: self.selectedAnnotaton))")
//
//
//        }
        
        
        
//        animateViewUp()
//        addSwipe()

    }
    
    
    @IBAction func centerUserLocation(_ sender: Any) {
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
