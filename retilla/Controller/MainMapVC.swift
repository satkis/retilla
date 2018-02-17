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

class MainMapVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!

    @IBOutlet weak var pullUpViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pullUpView: UIView!
    // var posts = [Post]()
    var post: Post!
    var coordinatesss: DatabaseReference!
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 5000
    
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
        locationAuthStatus()

        fetchCoordinates()
        
//        for add in addresses {
//            getPlaceMarkFromAddress(address: add)
//        }
        
        
        
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }


    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            map.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
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
    

    
    func createAnnotationforLocation(location: CLLocation) {
        let anot = Annotations(coordinate: location.coordinate, identifier: "droppablePin")
        map.addAnnotation(anot)
    }

    
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
        coordinatesss = DataService.instance.URL_BASE.child("posts")
        coordinatesss.observeSingleEvent(of: .value, with: { snapshot in
           
            for snap in snapshot.children {
                let postSnap = snap as! DataSnapshot
                if let dict = postSnap.value as? [String:AnyObject] {
                    let lat = dict["latitude"] as! CLLocationDegrees
                    let long = dict["longitude"] as! CLLocationDegrees
                    let titlee = dict["location"] as! String
                    
                    let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08))
                    
                    self.map.setRegion(region, animated: true)
                    
                    let pinCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
                    let annotation = Annotations(coordinate: pinCoordinate, identifier: "droppablePin")
                    annotation.coordinate = pinCoordinate
                    self.map.addAnnotation(annotation)
//                        MKPointAnnotation(title: titlee, coordinate: pinCoordrinate, info: postSnap)
                    
                    
//                    let annotation = MKPointAnnotation()
//                    annotation.coordinate = pinCoordrinate
//                    self.map.addAnnotation(annotation)
                }
            }
        })
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //nill to not make user location as a pin
            return nil
        } else {
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        pinAnnotation.pinTintColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        pinAnnotation.animatesDrop = true
        return pinAnnotation
        }
    }
    
    func animateViewUp() {
        pullUpViewHeightConstraint.constant = 300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        animateViewUp()
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
