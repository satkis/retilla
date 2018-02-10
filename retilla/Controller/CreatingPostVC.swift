//
//  CreatingPostVC.swift
//  retilla
//
//  Created by satkis on 2/10/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit

class CreatingPostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicker: UIImagePickerController!
    var imageSelected = false
    
    @IBOutlet weak var hashtagField: UITextField!
    
    @IBOutlet weak var descriptionField: UITextField!
    
    @IBOutlet weak var imageSelectorImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
       
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

    
    @IBAction func selectImageTapped(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func sharePost(_ sender: Any) {
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
