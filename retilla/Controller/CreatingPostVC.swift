//
//  CreatingPostVC.swift
//  retilla
//
//  Created by satkis on 2/10/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class CreatingPostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    var currentUser: DatabaseReference!
    var user: User!
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var imageDowloadURL: String!
    var descriptionText: String? = "user didn't include text"
    var hashtagText: String? = "user didn't include #hashtag"
    var posts = [Post]()
    var newPostKey = DataService.instance.URL_POSTS.childByAutoId().key
    var selectedSection: Int! = nil
    var postLocation: String! = "no city"
    var postCoordinates: String!
    var lat: String!
    var long: String!
    var postTimestamp: String! = "mmmm"
    var username: String! = "usrnm na"
    

    
    let locationManager = CLLocationManager()
    //let userVCRef = UserVC()
    
    private var image: UIImage!
    
    @IBOutlet weak var hashtagField: UITextField?
    
    @IBOutlet weak var descriptionField: UITextField?
    
    @IBOutlet weak var imageSelectorImage: UIImageView!
    
    @IBOutlet weak var locationLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad of CreatingPostVC")
        locationManager.delegate = self
        locationAuthStatus()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        currentUser = DataService.instance.URL_USER_CURRENT
        
        currentUser.observeSingleEvent(of: .value) { (snapshot) in
            
            let snap = snapshot.value as? Dictionary<String, AnyObject>
            print("snap::: \(String(describing: snap))")
            
            let key = snapshot.key
            let user = User(userKey: key, dictionary: snap!)
            
            if user.first_name != nil {
                self.username = user.first_name
            } else if user.email.contains("@") {
                let emailCutOff = user.email.components(separatedBy: "@").first
                self.username = emailCutOff
            } else if user.email.contains("Anonymous") {
                self.username = "Anonymous"
            } else {
                self.username = "no user ID"
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear of CreatingPostVC")
        
    }
    
    // NEED TO CORRECT doesnt disable if image not selected
//    func dismissAnyBeforeImageSelected() {
//        if let image = imageSelectorImage.image, imageSelectorImage.image == nil {
//            self.hashtagField.isUserInteractionEnabled = false
//            hashtagField.isEnabled = false
//            self.descriptionField.isUserInteractionEnabled = false
//
//        }
//    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageSelectorImage.contentMode = .scaleAspectFit
            imageSelectorImage.image = editedImage
            imageSelected = true
            
        } else if let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageSelectorImage.contentMode = .scaleAspectFit
            imageSelectorImage.image = pickerImage
            imageSelected = true
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }

    func postToFirebase(imageDownloadURL: String!, descriptionText: String?, hashtagText: String?, selectedSection: Int!, postLocation: String!, postCoordinates: String!, postTimestamp: String!, lat: String!, long: String!, username: String!) {
        
       let postTimestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
     
        let lat = locationManager.location?.coordinate.latitude
        let long = locationManager.location?.coordinate.longitude
        
        
        //let ree = self.userVCRef.currentUser_DBRef.key
        
        //let tyy = DataService.instance.URL_USER_CURRENT.

       // print("ree:: \(ree)")
        let post: Dictionary<String, Any> = [
            "imageUrl": imageDowloadURL!,
            "description": descriptionField?.text as Any,
            "hashtag": hashtagField?.text as Any,
            "likes": 0,
            "section": selectedSection as Int,
            "location": locationLbl.text as Any,
            "coordinates": String(describing: (lat!) as Any)+","+String(describing: (long!) as Any),
            "timestamp": postTimestamp as Any,
            "latitude": lat as Any,
            "longitude": long as Any,
            "username": username as Any
            ]
        
        
//        if descriptionField?.text != "" {
//           post ["description"] = descriptionField
//        }
//
//        if hashtagField?.text != "" {
//            post ["hashtag"] = hashtagField
//        }
//self.newPostKey = firebasePost
    let firebasePost = DataService.instance.URL_POSTS.child(newPostKey)
        print("firebasePost:: \(firebasePost)")
        firebasePost.setValue(post)
        print("post:: \(post)")
        
        let firebasePostToUser = DataService.instance.URL_USER_CURRENT.child("posts").child(newPostKey)
        firebasePostToUser.setValue(true)
        
        hashtagField?.text = ""
        descriptionField?.text = ""
        imageSelectorImage.image = UIImage(named: "camera-icon-hi")
        imageSelected = false
        
        //NEED TO reload data somehow here // or maybe not. looks like tables reload after posting (but need to adjust sequence of posts).
        
    }

    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            print(loc)
            let lat = loc.coordinate.latitude
            let long = loc.coordinate.longitude
           
            
            print("latitudeeeeeeeee: \(lat)", "longitudeeeeeeeeee: \(long)")
            
            CLGeocoder().reverseGeocodeLocation(loc, completionHandler: { (placemark, error) in
                if error == nil {
                    if let place = placemark?[0] {
                        if let locality = place.locality {
                            self.locationLbl.text = locality
                        } else {
                            if let country = place.country {
                                self.locationLbl.text = country
                            } else {
                                self.locationLbl.text = "n/a"
                            }
                        }
                    }
                } else {
                    debugPrint("location error: \(String(describing: error))")
                }
            })
        }
    }
    
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        if let loc = userLocation.location {
//            print("location loc: \(loc)")
//            let lat = loc.coordinate.latitude
//            let long = loc.coordinate.longitude
//
//            print("latitude: \(lat)", "longitude: \(long)")
//
//            CLGeocoder().reverseGeocodeLocation(loc, completionHandler: { (placemark, error) in
//                if error != nil {
//                    debugPrint("location error: \(error)")
//                } else {
//                    if let place = placemark?[0] {
//                        if let locality = place.locality {
//                            self.locationLbl.text = locality
//                        } else {
//                            print("nil value for locationLbl")
//                        }
//                        print("administrativeArea: \(String(describing: place.administrativeArea))")
//                        print("areasOfInterest: \(String(describing: place.areasOfInterest))")
//                        print("country: \(String(describing: place.country))")
//                        print("inlandWater: \(String(describing: place.inlandWater))")
//                        print("locality: \(String(describing: place.locality))")
//                        print("isoCountryCode: \(String(describing: place.isoCountryCode))")
//                        print("name: \(String(describing: place.name))")
//                        print("ocean: \(String(describing: place.ocean))")
//                        print("postalCode: \(String(describing: place.postalCode))")
//                        print("region: \(String(describing: place.region))")
//                        print("subAdministrativeArea: \(String(describing: place.subAdministrativeArea))")
//                        print("subLocality: \(String(describing: place.subLocality))")
//                        print("subThoroughfare: \(String(describing: place.subThoroughfare))")
//                        print("timeZone: \(String(describing: place.timeZone))")
//                    }
//                }
//            })
//        }
//    }
    
    
    
    
        
    @IBAction func selectImageTapped(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func selectedSectionn(_ sender: UISegmentedControl) {
        
        selectedSection = sender.selectedSegmentIndex
//        sender.selectedSegmentIndex = selectedSection.hashValue
        print("segment selected::: \(selectedSection)")
    }
//        if sender.selectedSegmentIndex == 0 {
//            sender.selectedSegmentIndex = selectedSection.hashValue
//            print("segment selected::: \(selectedSection.hashValue)")
//        } else {
//            if sender.selectedSegmentIndex == 1 {
//                sender.selectedSegmentIndex = selectedSection.hashValue
//                print("segment selected::: \(selectedSection.hashValue)")
//            } else {
//                if sender.selectedSegmentIndex == 2 {
//                    sender.selectedSegmentIndex = selectedSection.hashValue
//                    print("segment selected::: \(selectedSection.hashValue)")
//                } else {
//                    if sender.selectedSegmentIndex == 3 {
//                        sender.selectedSegmentIndex = selectedSection.hashValue
//                        print("segment selected::: \(selectedSection.hashValue)")
//                    }
//                }
//            }
//        }
//            print("smth wrong with selectedSectionn value")
        
//    }
    
    @IBAction func sharePost(_ sender: Any) {
        if let imageIsSelected = imageSelectorImage.image, imageSelected == true && selectedSection != nil {
            if let uploadData = UIImageJPEGRepresentation(self.imageSelectorImage.image!, 0.3) {
                print("uploadData::: \(uploadData)")
                let metadata = StorageMetadata()
                print("metadata::: \(uploadData)")
                let newPostRef = DataService.instance.URL_POSTS.childByAutoId()
                print("newPostRef::: \(newPostRef)")
                let newPostKey = newPostRef.key
                print("newPostKey::: \(newPostKey)")
                
                self.newPostKey = newPostKey
                let imageStorageRef = Storage.storage().reference().child("images")
                print("imageStorageRef::: \(imageStorageRef)")
                let newImageRef = imageStorageRef.child(newPostKey + ".jpeg")
                print("newImageRef::: \(newImageRef)")
                newImageRef.putData(uploadData, metadata: metadata).observe(.success, handler: { (snapshot) in
                    //save the post caption & download url
                    print("snapshot:: \(snapshot)")
                    self.imageDowloadURL = snapshot.metadata?.downloadURL()?.absoluteString
                    print("imageDowloadURL:: \(self.imageDowloadURL)")
                    self.postToFirebase(imageDownloadURL: self.imageDowloadURL, descriptionText: self.descriptionText, hashtagText: self.hashtagText, selectedSection: self.selectedSection, postLocation: self.postLocation, postCoordinates: self.postCoordinates, postTimestamp: self.postTimestamp, lat: self.lat, long: self.long, username: self.username)
                    
                    self.dismiss(animated: true, completion: nil)
                })
            } else {
                print("image not selected but SHARE tapped")
                postToFirebase(imageDownloadURL: nil, descriptionText: "WRONG", hashtagText: "WRONG", selectedSection: 0, postLocation: "WRONG", postCoordinates: "WRONG", postTimestamp: "n/aa", lat: "na/aa", long: "nn/aa", username: "noo usrnm")
                print("saved to Firebase nil image")
                dismiss(animated: true, completion: nil)
            }
        }
    }
            


}
    


