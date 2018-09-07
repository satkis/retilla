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

class CreatingPostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
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
    var postLocation_city: String! = "noo city"
    var postLocation_country: String! = "noo country"
    var postCoordinates: String!
    var lat: String!
    var long: String!
    var postTimestamp: String! = "mmmm"
    var username: String! = "usrnm na"
    var placeholderLabel: UILabel!
    var locationManager = CLLocationManager()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    private var image: UIImage!
    
    let authorizationStatus = CLLocationManager.authorizationStatus()
    
    
    @IBOutlet weak var chooseLbl: UILabel!
    @IBOutlet weak var explanationLbl: UIStackView!
    @IBOutlet weak var hashtagField: UITextField?
    
    @IBOutlet weak var imageSelectorImage: UIImageView!
    
    
    @IBOutlet var userCamera: UIImageView!
    @IBOutlet var storyTextVIew: UITextView!
    
    @IBOutlet weak var postSegments: UISegmentedControl!
    @IBOutlet weak var textForGuestsLbl: UILabel!
    
    @IBOutlet weak var buttonForGuestsLbl: UIButton!
    
    @IBOutlet weak var sharePostBttnLbl: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseLbl.alpha = 0
        explanationLbl.alpha = 0
        
        storyTextVIew.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "type a story about your photo"
        placeholderLabel.font = UIFont.systemFont(ofSize: (storyTextVIew.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        storyTextVIew.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (storyTextVIew.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !storyTextVIew.text.isEmpty
        
        
        
        print("viewDidLoad of CreatingPostVC")
        locationManager.delegate = self
        
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
            } else if user.email.contains("Guest") {
                self.username = "Guest"
            } else {
                self.username = "no user ID"
            }
        }
        
        configureLocationServices()
        
        if CLLocationManager.locationServicesEnabled() {
            print("userLocationUPD_ViewDIdLoad_createPostVC")
            locationManager.startUpdatingLocation()
            
        } else {
            locationManager.stopUpdatingLocation()
            print("not updating user location_CreatePostVC")
            
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        currentUser.observeSingleEvent(of: .value) { (snapshot) in
            
            let snap = snapshot.value as? Dictionary<String, AnyObject>
            print("snap::: \(String(describing: snap))")
            
            let key = snapshot.key
            let user = User(userKey: key, dictionary: snap!)
            
            if user.email.contains("Guest") {
                self.textForGuestsLbl.isHidden = false
                self.buttonForGuestsLbl.isHidden = false
            } else {
                self.textForGuestsLbl.isHidden = true
                self.buttonForGuestsLbl.isHidden = true
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear of CreatingPostVC")
        
        if authorizationStatus == .denied {
            print("access declined_viewDidAppear")
            showErrorAlert(title: "As you denied access to your location, you cannot create posts", msg: "If you want to create posts, enable location access in your iPhone settings")
            self.sharePostBttnLbl.isEnabled = false
            locationManager.stopUpdatingLocation()
        } else if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            print("allowedLocation_viewDidAppear")
            if CLLocationManager.locationServicesEnabled() {
                print("start upd location_viewDidAppear")
                locationManager.startUpdatingLocation()
            } else {
                
                print("nzn nzn nzn_viewDidAppear")
                return
                
            }
        } else {
            print("returnreturnretrun")
            return
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageSelectorImage.contentMode = .scaleAspectFit
            imageSelectorImage.image = editedImage
            imageSelected = true
            
        } else if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage
            imageSelectorImage.contentMode = .scaleAspectFit
            imageSelectorImage.image = pickedImage
            imageSelected = true
            
        }
        picker.dismiss(animated: true, completion: nil)
        
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func postToFirebase(imageDownloadURL: String!, descriptionText: String?, hashtagText: String?, selectedSection: Int!, postLocation_city: String!, postLocation_country: String!, postCoordinates: String!, postTimestamp: String!, lat: String!, long: String!, username: String!) {
        
        let postTimestamp = [".sv": "timestamp"]
        
        let lat = (locationManager.location?.coordinate.latitude)!
        let long = (locationManager.location?.coordinate.longitude)! // Double(randomPlus)
        
        let post: Dictionary<String, Any> = [
            "imageUrl": imageDowloadURL!,
            "description": storyTextVIew?.text as Any,
            "hashtag": hashtagField?.text as Any,
            "likes": 0,
            "section": selectedSection as Int,
            "location_city": postLocation_city as Any,
            "location_country": postLocation_country as Any,
            "coordinates": String(describing: (lat) as Any)+","+String(describing: (long) as Any),
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
        
        let firebasePost = DataService.instance.URL_POSTS.child(newPostKey)
        print("firebasePost:: \(firebasePost)")
        firebasePost.setValue(post)
        print("post:: \(post)")
        
        let firebasePostToUser = DataService.instance.URL_USER_CURRENT.child("posts").child(newPostKey)
        firebasePostToUser.setValue(userPost)
        
        hashtagField?.text = ""
        storyTextVIew.text = ""
        imageSelectorImage.image = UIImage(named: "camera-icon-hi")
        imageSelected = false
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations:::")
        if let loc = locations.first {
            print("loclocloc:::", loc)
            let lat = loc.coordinate.latitude
            let long = loc.coordinate.longitude
            
            print("latitudeeeeeeeee: \(lat)", "longitudeeeeeeeeee: \(long)")
            
            CLGeocoder().reverseGeocodeLocation(loc, completionHandler: { (placemark, error) in
                if error == nil {
                    
                    if let place = placemark?[0] {
                        print("placeplaceplace:::", place)
                        if let locality = place.locality {
                            self.postLocation_city = locality
                            self.postLocation_country = place.country
                            
                        } else {
                            self.postLocation_city = "n/a"
                            self.postLocation_country = "n/a"
                            
                        }
                    }
                } else {
                    debugPrint("location error: \(String(describing: error))")
                }
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func selectImageTapped(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func openCameraTapped(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    
    @IBAction func selectedSectionn(_ sender: UISegmentedControl) {
        selectedSection = sender.selectedSegmentIndex
        print("segment selected::: \(selectedSection)")
    }
    
    @IBAction func sharePost(_ sender: Any) {
        if let _ = imageSelectorImage.image, imageSelected == true  {
            if selectedSection != nil {
                
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                view.addSubview(activityIndicator)
                
                activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                
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
                    
                    newImageRef.putData(uploadData, metadata: metadata).observe(.success, handler: { (snapshot) in
                        //save the post caption & download url
                        print("snapshot:: \(snapshot)")
                        self.imageDowloadURL = snapshot.metadata?.downloadURL()?.absoluteString
                        print("imageDowloadURL:: \(self.imageDowloadURL)")
                        
                        self.postToFirebase(imageDownloadURL: self.imageDowloadURL, descriptionText: self.descriptionText, hashtagText: self.hashtagText, selectedSection: self.selectedSection, postLocation_city: self.postLocation_city, postLocation_country: self.postLocation_country, postCoordinates: self.postCoordinates, postTimestamp: self.postTimestamp, lat: self.lat, long: self.long, username: self.username)
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: "createdPost", sender: nil)
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
                self.textForGuestsLbl.alpha = 0
                self.buttonForGuestsLbl.alpha = 0
                self.chooseLbl.alpha = 1
                self.explanationLbl.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.textForGuestsLbl.alpha = 1
                self.buttonForGuestsLbl.alpha = 1
                self.chooseLbl.alpha = 0
                self.explanationLbl.alpha = 0
            }
        }
    }
    
    
    @IBAction func guestLoginwithDiffAcctTapped(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
        
        let initialVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = initialVC
        
    }
    
    
    
    
}

extension CreatingPostVC: CLLocationManagerDelegate {
    
    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            
        } else if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            print("allowedLocation_configureLocationServices_CreatePostVC")
            if CLLocationManager.locationServicesEnabled() {
                print("start upd location_configureLocationServices_CreatePostVC")
                locationManager.startUpdatingLocation()
                
            } else {
                
                print("nzn nzn nzn_configureLocationServices_CreatePostVC")
                return
                
            }
        } else {
            print("returnreturnretrun_configureLocationServices_CreatePostVC")
            return
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted {
            print("access declined")
            showErrorAlert(title: "As you denied access to your location, you cannot create posts", msg: "If you want to create posts, enable location access in your iPhone settings")
            self.sharePostBttnLbl.isEnabled = false
            locationManager.stopUpdatingLocation()
        } else if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            print("allowedLocation")
            if CLLocationManager.locationServicesEnabled() {
                print("start upd location")
                locationManager.startUpdatingLocation()
            } else {
                
                print("nzn nzn nzn")
                return
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




