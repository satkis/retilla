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

class CreatingPostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UITextViewDelegate {

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
    var postLocation_city: String! = "no city"
    var postLocation_country: String! = "no country"
    var postCoordinates: String!
    var lat: String!
    var long: String!
    var postTimestamp: String! = "mmmm"
    var username: String! = "usrnm na"
    var placeholderLabel: UILabel!

    
    let locationManager = CLLocationManager()
    //let userVCRef = UserVC()
    
    private var image: UIImage!
    
    
    @IBOutlet weak var chooseLbl: UILabel!
    @IBOutlet weak var explanationLbl: UIStackView!
    @IBOutlet weak var hashtagField: UITextField?
    
    @IBOutlet weak var imageSelectorImage: UIImageView!
    
    //@IBOutlet weak var usersCamera: UIImageView!
    
    @IBOutlet var userCamera: UIImageView!
    @IBOutlet var storyTextVIew: UITextView!
    
    @IBOutlet weak var postSegments: UISegmentedControl!
    
    //@IBOutlet weak var locationLbl_city: UILabel!
    
    //@IBOutlet weak var locationLbl_country: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseLbl.alpha = 0
        explanationLbl.alpha = 0
        
        storyTextVIew.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "type a story about your photo"
//        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (storyTextVIew.font?.pointSize)!)
        placeholderLabel.font = UIFont.systemFont(ofSize: (storyTextVIew.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        storyTextVIew.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (storyTextVIew.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !storyTextVIew.text.isEmpty
    
    

        print("viewDidLoad of CreatingPostVC")
        locationManager.delegate = self
        locationAuthStatus()
//        handleLocationAuthorizationStatus(status: )
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

func textViewDidChange(_ textView: UITextView) {
    placeholderLabel.isHidden = !textView.text.isEmpty
}


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageSelectorImage.contentMode = .scaleAspectFit
            imageSelectorImage.image = editedImage
            imageSelected = true
//
//        } else if let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            imageSelectorImage.contentMode = .scaleAspectFit
//            imageSelectorImage.image = pickerImage
//
//            imageSelected = true
        } else if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage
            imageSelectorImage.contentMode = .scaleAspectFit
//            userCamera.contentMode = .scaleAspectFit
            imageSelectorImage.image = pickedImage
//            userCamera.image = pickedImage
            imageSelected = true
            
//        } else if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
//            userCamera.contentMode = .scaleToFill
//            userCamera.image = pickedImage
//            imageSelected = true
        }
        picker.dismiss(animated: true, completion: nil)
            
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
//    @IBAction func openCameraTapped(_ sender: UITapGestureRecognizer) {
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//            imagePicker.allowsEditing = false
    
//
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            userCamera.contentMode = .scaleToFill
//            userCamera.image = pickedImage
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
//

    func postToFirebase(imageDownloadURL: String!, descriptionText: String?, hashtagText: String?, selectedSection: Int!, postLocation_city: String!, postLocation_country: String!, postCoordinates: String!, postTimestamp: String!, lat: String!, long: String!, username: String!) {
        
//       let postTimestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        let postTimestamp = [".sv": "timestamp"]
        
        //let rr = ServerValue.timestamp()
     
        let lat = locationManager.location?.coordinate.latitude
        let long = locationManager.location?.coordinate.longitude
        
        
        //let ree = self.userVCRef.currentUser_DBRef.key
        
        //let tyy = DataService.instance.URL_USER_CURRENT.

       // print("ree:: \(ree)")
        let post: Dictionary<String, Any> = [
            "imageUrl": imageDowloadURL!,
            //"description": descriptionField?.text as Any,
            "description": storyTextVIew?.text as Any,
            "hashtag": hashtagField?.text as Any,
            "likes": 0,
            "section": selectedSection as Int,
            
            "location_city": postLocation_city as Any,
            "location_country": postLocation_country as Any,
            
//            "location_city": locationLbl_city.text as Any,
//            "location_country": locationLbl_country.text as Any,
            "coordinates": String(describing: (lat!) as Any)+","+String(describing: (long!) as Any),
            "timestamp": postTimestamp as Any,
            "latitude": lat as Any,
            "longitude": long as Any,
            "username": username as Any
            ]
        
        let userPost: Dictionary<String, Any> = [
            "imageUrl": imageDowloadURL!,
            "section": selectedSection as Int,
            "description": storyTextVIew?.text as Any,
            "hashtag": hashtagField?.text as Any,
            "location_city": postLocation_city as Any,
            "location_country": postLocation_country as Any,
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
        firebasePostToUser.setValue(userPost)
        
        hashtagField?.text = ""
        //descriptionField?.text = ""
        storyTextVIew.text = ""
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
                            self.postLocation_city = locality
                            self.postLocation_country = place.country
//                            self.locationLbl_city.text = locality
//                            self.locationLbl_country.text = place.country
                        } else {
                            self.postLocation_city = "n/a"
                            self.postLocation_country = "n/a"
//                            self.locationLbl_city.text = "n/a"
//                            self.locationLbl_country.text = "n/aa"
                        }
                    }
                } else {
                    debugPrint("location error: \(String(describing: error))")
                }
            })
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        handleLocationAuthorizationStatus(status: status)
//    }
    
    // Respond to the result of the location manager authorization status
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied:
            print("I'm sorry - I can't show location. User has not authorized it")
        case .restricted:
            print("Access denied - likely parental controls are restricting use in this app.")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            userCamera.contentMode = .scaleToFill
//            userCamera.image = pickedImage
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
 
    
        
    @IBAction func selectImageTapped(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func openCameraTapped(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {

            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            //self.presentedViewController(imagePicker, animated: true, completion: nil)
            
//            presentedViewController(imagePicker, animated: true, completion: nil)
            
//            present(imagePickerController, animated: true, completion: nil)
//            imagePicker.cameraCaptureMode = .photo
//            imagePicker.modalPresentationStyle = .fullScreen
            //var picker = UIImagePickerController()
            //imagePicker.allowsEditing = false
//            imagePicker.sourceType = UIImagePickerControllerSourceType.camera

//
            present(imagePicker, animated: true, completion: nil)
//        } else {
//            noCamera()
//        }
    }
    }
    
    

    
    
//    func noCamera(){
//        let alertVC = UIAlertController(
//            title: "No Camera",
//            message: "Sorry, someting is wrong with camera. Pick a photo from your Library",
//            preferredStyle: .alert)
//        let okAction = UIAlertAction(
//            title: "OK",
//            style:.default,
//            handler: nil)
//        alertVC.addAction(okAction)
//        present(
//            alertVC,
//            animated: true,
//            completion: nil)
//    }
    


    
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
        if let _ = imageSelectorImage.image, imageSelected == true  {
            if selectedSection != nil {
            
            if let uploadData = UIImageJPEGRepresentation(self.imageSelectorImage.image!, 0.3) {
                print("uploadData::: \(uploadData)")
                let metadata = StorageMetadata()
                print("metadata::: \(uploadData)")
                let newPostRef = DataService.instance.URL_POSTS.childByAutoId()
                print("newPostRef::: \(newPostRef)")
                let newPostKey = newPostRef.key
                print("newPostKey::: \(newPostKey)")
                
                self.newPostKey = newPostKey
                let storRef = Storage.storage().reference()
                let imageStorageRef = Storage.storage().reference().child("images")
                print("imageStorageRef::: \(imageStorageRef)")
                let newImageRef = imageStorageRef.child(newPostKey + ".jpeg")
                print("newImageRef::: \(newImageRef)")
//                imageStorageRef.downloadURL(completion: { (url, error) in
//                    if let error = error {
//                        print("error:p: \(error)")
//                    } else {
//                        print("imgg: \(String(describing: url))")
//                    }
//                })
//                newImageRef.putData(uploadData).observe(.success) { snapshot in
//
//                    newImageRef.downloadURL(completion: { (url, err) in
//                        if (error == nil) {
//                            if let downloadUrl = url {
//                                let downloadString = downloadUrl.absoluteString
//                                self.imageDowloadURL = downloadString
//                                print("urlurl \(self.imageDowloadURL)")
//                            }
//                        } else {
//                            print("errerr\(String(describing: error))")
//                        }
//                    })
//                }
                //                this one whas the initial:: newImageRef.putData(uploadData, metadata: metadata).observe(.success, handler: { (snapshot) in
//                newImageRef.putData(uploadData).observe(.success) { snapshot in
//                let storage = Storage.storage().reference()
//
//                newImageRef.putData(uploadData, metadata: nil) { (metadata, error) in
//
//                if error == nil {
//
//                    Storage.storage().reference().child("images").child(newPostKey+".jpeg").downloadURL(completion: { (urlll, errr) in
//                        if let error = error {
//                            print(errr)
//                        } else {
//                            print("rerere \(String(describing: urlll))")
//                        }
//                    })
//
//                    print("errorrMetadata: \(error)")
//
//                } else {
//                    return
//                    }
                newImageRef.putData(uploadData, metadata: metadata).observe(.success, handler: { (snapshot) in
                    //save the post caption & download url
                    print("snapshot:: \(snapshot)")
                    self.imageDowloadURL = snapshot.metadata?.downloadURL()?.absoluteString
                    print("imageDowloadURL:: \(self.imageDowloadURL)")
                    
                    
                    self.postToFirebase(imageDownloadURL: self.imageDowloadURL, descriptionText: self.descriptionText, hashtagText: self.hashtagText, selectedSection: self.selectedSection, postLocation_city: self.postLocation_city, postLocation_country: self.postLocation_country, postCoordinates: self.postCoordinates, postTimestamp: self.postTimestamp, lat: self.lat, long: self.long, username: self.username)
                    
                    self.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: "createdPost", sender: nil)
                    
//                    let FeedVC: FeedVCC = self.storyboard?.instantiateViewController(withIdentifier: "FeedVCC") as! FeedVCC
//                    let nvc: UITabBarController = self.storyboard?.instantiateViewController(withIdentifier: "barController") as! UITabBarController
//
//                    nvc.viewControllers = [FeedVC]
                    
//                    let navigationController = UINavigationController(rootViewController: FeedVC)
//                    self.window??.rootViewController = navigationController
//                   UIApplication.shared.keyWindow?.rootViewController = nvc
                    
                    
//                    let appDelegate = UIApplication.shared.delegate
//                    let FeedVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedVCC") as! FeedVCC
//                    let nav = UINavigationController(rootViewController: FeedVC)
//
//                    appDelegate?.window??.rootViewController = nav
                    
//
//                    let rootVC: FeedVCC = self.storyboard?.instantiateViewController(withIdentifier: "FeedVCC") as! FeedVCC
//                    let nvc: UITabBarController = self.storyboard?.instantiateViewController(withIdentifier: "barController") as! UITabBarController
//
//                    nvc.viewControllers = [rootVC]
//                    UIApplication.shared.keyWindow?.rootViewController = nvc
                    
//                    let mainStoryBoard = self.storyboard?.instantiateViewController(withIdentifier: "FeedVCC") as! FeedVCC
//                    let viewController = self.mainStoryBoard.instantiateViewController(withIdentifier: "barController") as! UITabBarController
//                    UIApplication.shared.keyWindow?.rootViewController = viewController
                 
                })
            } else {
                print("image not selected but SHARE tapped")
                postToFirebase(imageDownloadURL: nil, descriptionText: "WRONG", hashtagText: "WRONG", selectedSection: 0, postLocation_city: "WRONG", postLocation_country: "WRONG", postCoordinates: "WRONG", postTimestamp: "n/aa", lat: "na/aa", long: "nn/aa", username: "noo usrnm")
                print("saved to Firebase nil image")
                performSegue(withIdentifier: "createdPost", sender: nil)
                

                
                }
            } else {
                postSegments.shake()
            }
        } else {
            imageSelectorImage.shake()
            userCamera.shake()
        }
    }
    
    
    @IBAction func explanationTapped(_ sender: Any) {
        
        if self.chooseLbl.alpha == CGFloat(0) {
            
            UIView.animate(withDuration: 0.3) {
                self.chooseLbl.alpha = 1
                self.explanationLbl.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.chooseLbl.alpha = 0
                self.explanationLbl.alpha = 0
            }
        }
    }
    
    


}

extension UISegmentedControl {
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 8, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 8, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}

extension UIImageView {
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 8, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 8, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}

    


