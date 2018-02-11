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
    var imageDowloadURL: String!
    var descriptionText: String? = "user didn't include text"
    var hashtagText: String? = "user didn't include #hashtag"
    var posts = [Post]()
    var newPostKey = DataService.instance.URL_POSTS.childByAutoId().key
    
    private var image: UIImage!
    
    @IBOutlet weak var hashtagField: UITextField?
    
    @IBOutlet weak var descriptionField: UITextField?
    
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

    
    func postToFirebase(imageDownloadURL: String!, descriptionText: String?, hashtagText: String?) {
        let post: Dictionary<String, Any> = [
            "imageUrl": imageDowloadURL!,
            "description": descriptionField?.text as Any,
            "hashtag": hashtagField?.text as Any,
            "likes": 0
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
        
        hashtagField?.text = ""
        descriptionField?.text = ""
        imageSelectorImage.image = UIImage(named: "camera-icon-hi")
        imageSelected = false
        
        //NEED TO reload data somehow here // or maybe not. looks like tables reload after posting (but need to adjust sequence of posts).
        
    }
        
    @IBAction func selectImageTapped(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func sharePost(_ sender: Any) {
        if let imageIsSelected = imageSelectorImage.image, imageSelected == true {
            if let uploadData = UIImageJPEGRepresentation(self.imageSelectorImage.image!, 0.6) {
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
                    self.postToFirebase(imageDownloadURL: self.imageDowloadURL, descriptionText: self.descriptionText, hashtagText: self.hashtagText)
                    self.dismiss(animated: true, completion: nil)
                })
            } else {
                print("image not selected but SHARE tapped")
                postToFirebase(imageDownloadURL: nil, descriptionText: "somehow user posted without image included", hashtagText: "somehow user posted without image included")
                print("saved to Firebase nil image")
                dismiss(animated: true, completion: nil)
            }
        }
    }
            
            
            
//            let newPostKey = DataService.instance.URL_POSTS.key
//            let new posss = DataSnapshot.childSnapshot(DataSnapshot
//            print("newPostKey:: \(newPostKey)")
//            if let imageData = UIImageJPEGRepresentation(self.imageSelectorImage.image!, 0.6){
//                print("imageData:: \(imageData)")
//                //create a new storage reference
//                let imageStorageRef = Storage.storage().reference().child("images")
//                print("imageStorageRef:: \(imageStorageRef)")
//                let newImageRef = imageStorageRef.child(newPostKey)
//                print("newImageRef:: \(newImageRef)")
//                //save img to storage
//                newImageRef.putData(imageData).observe(.success, handler: { (snapshot) in
//                    //save the post caption & download url
//                    print("snapshot:: \(snapshot)")
//                    self.imageDowloadURL = snapshot.metadata?.downloadURL()?.absoluteString
//                    print("imageDowloadURL:: \(self.imageDowloadURL)")
//                    self.postToFirebase(imageDownloadURL: self.imageDowloadURL)
//                    self.dismiss(animated: true, completion: nil)
//                })
//            }
//        } else {
//            print("image not selected but SHARE tapped")
//            postToFirebase(imageDownloadURL: nil)
//            print("saved to Firebase nil image")
//            dismiss(animated: true, completion: nil)
//        }
//    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */

}
