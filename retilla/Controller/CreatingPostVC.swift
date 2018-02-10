//
//  CreatingPostVC.swift
//  retilla
//
//  Created by satkis on 2/10/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit
import Firebase

class CreatingPostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var imageDowloadURL: String?
    var posts = [Post]()
    
    @IBOutlet weak var hashtagField: UITextField!
    
    @IBOutlet weak var descriptionField: UITextField!
    
    @IBOutlet weak var imageSelectorImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
       
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
    
   // func save() {
//        let newPostKey = DataService.instance.URL_POSTS.key
//
//        if let imageData = UIImageJPEGRepresentation(self.imageSelectorImage.image!, 0.6) {
//        //create a new storage reference
//        let imageStorageRef = Storage.storage().reference().child("images")
//        let newImageRef = imageStorageRef.child(newPostKey)
//            //save img to storage
//            newImageRef.putData(imageData).observe(.success, handler: { (snapshot) in
//                //save the post caption & download url
//                self.imageDowloadURL = snapshot.metadata?.downloadURL()?.absoluteString
//                self.postToFirebase(imageDownloadURL: self.imageDowloadURL)
//
//            })
//    }
    //}
    
    func postToFirebase(imageDownloadURL: String!) {
        var post: Dictionary<String, Any> = [
            "imageUrl": imageDowloadURL!,
            "likes": 0
            ]
        
        if descriptionField.text != "" {
           post ["description"] = descriptionField
        }
        
        if hashtagField.text != "" {
            post ["hashtag"] = hashtagField
        }

    let firebasePost = DataService.instance.URL_POSTS.childByAutoId()
    firebasePost.setValue(post)
        
        descriptionField.text = ""
        imageSelectorImage.image = UIImage(named: "camera-icon-hi")
        imageSelected = false
        
        //NEED TO reload data somehow here
        
    
        
    }
        
    @IBAction func selectImageTapped(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func sharePost(_ sender: Any) {
        if let imageIsSelected = imageSelectorImage.image, imageSelected == true {
            let newPostKey = DataService.instance.URL_POSTS.key
            
            if let imageData = UIImageJPEGRepresentation(self.imageSelectorImage.image!, 0.6) {
                //create a new storage reference
                let imageStorageRef = Storage.storage().reference().child("images")
                let newImageRef = imageStorageRef.child(newPostKey)
                //save img to storage
                newImageRef.putData(imageData).observe(.success, handler: { (snapshot) in
                    //save the post caption & download url
                    self.imageDowloadURL = snapshot.metadata?.downloadURL()?.absoluteString
                    self.postToFirebase(imageDownloadURL: self.imageDowloadURL)
                    self.dismiss(animated: true, completion: nil)
                })
            }
        } else {
            print("image not selected but SHARE tapped")
            postToFirebase(imageDownloadURL: nil)
            print("saved to Firebase nil image")
            dismiss(animated: true, completion: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
