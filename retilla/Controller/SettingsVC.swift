//
//  SettingsVC.swift
//  retilla
//
//  Created by satkis on 5/13/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    var currentUser: DatabaseReference!
    var user: User!
    var feedbackFieldTxt: String! = "no no no"
    var userContactFieldTxt: String! = "no contact"
    var username: String! = "user nmm"
    var feedbackTimestamp: String! = "smth wrongg"
    var newFeedbackKey = DataService.instance.URL_POSTS.childByAutoId().key
//    var userLocationCountry: String? = "no country"
//    var userLocationCity: String? =  "no cityy"
    
//    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var feedbackTxtField: UITextField!
    @IBOutlet weak var userEmailTxtField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var appearFeedbackLbl: UILabel!
    @IBOutlet weak var appearFeedbackWIthContactLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appearFeedbackLbl.alpha = 0
        appearFeedbackWIthContactLbl.alpha = 0
        //feedbackTxtField.delegate = self
        
//        sendButton.isUserInteractionEnabled = false
//        sendButton.isEnabled = false
//        if (feedbackTxtField.text?.count)! < 5 {
//            sendButton.isEnabled = false
////            sendButton.alpha = 0.3
//        } else {
//            sendButton.isEnabled = true
//        }
    
//        sendButton.isUserInteractionEnabled = false
//        sendButton.alpha = 0.3
        
//        if self.feedbackTxtField.hasText {
//            sendButton.isUserInteractionEnabled = true
//            sendButton.alpha = 1
//        } else {
//            sendButton.isUserInteractionEnabled = false
//            sendButton.alpha = 0.3
//        }

//
//        currentUser.observeSingleEvent(of: .value) { (snapshot) in
//
//            let snap = snapshot.value as? Dictionary<String, AnyObject>
//            print("snapInSettingsVC::: \(String(describing: snap))")
//            let key = snapshot.key
//            let user = User(userKey: key, dictionary: snap!)
//
//            if user.email != nil {
//                self.username = user.email
//
//            } else {
//                self.username = "not Identified Username"
//            }
//
//        }
//
//        if user.email = NSNull {
//            self.username = user.email
//        } else {
//            self.username = "not identified username"
//        }
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if (feedbackTxtField.text?.count)! > 5 {
//            sendButton.isUserInteractionEnabled = true
//            sendButton.isEnabled = true
//        } else {
//            sendButton.isUserInteractionEnabled = false
//            sendButton.isEnabled = false
//        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    
    func postToFirebase(username: String!, feedbackFieldTxt: String!, userContactFieldTxt: String!, feedbackTimestamp: String!) {
        
        let feedbackTimestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        
        let username = "ddd"
        
        let feedback: Dictionary<String, Any> = [
            "feedback_Time": feedbackTimestamp as Any,
            "username": username as Any,
            "user_typed_contacts": userEmailTxtField!.text! as Any,
            "feedback": feedbackTxtField.text! as Any
        ]
        
        let firebaseFeedback = DataService.instance.URL_FEEDBACK.child(newFeedbackKey)
        firebaseFeedback.setValue(feedback)
        feedbackTxtField.text = ""
        userEmailTxtField.text = ""
    }
    
    func postingDetails() {
        let newFeedbackRef = DataService.instance.URL_FEEDBACK.childByAutoId()
        let newFeedbackKey = newFeedbackRef.key
        self.newFeedbackKey = newFeedbackKey
        
        self.postToFirebase(username: self.username, feedbackFieldTxt: self.userEmailTxtField.text, userContactFieldTxt: self.userEmailTxtField.text, feedbackTimestamp: self.feedbackTimestamp)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
            self.appearFeedbackLbl.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 2.2, delay: 2.2, options: .curveEaseInOut, animations: {
            self.appearFeedbackLbl.alpha = 0.0
        }, completion: nil)
        
    }

    
    @IBAction func sendFeedbackPressed(_ sender: Any) {
        if self.feedbackTxtField.text != "", self.feedbackTxtField.text != " ", self.feedbackTxtField.text != "  ", self.feedbackTxtField.text != "   ", self.feedbackTxtField.text != "    " {
            if self.userEmailTxtField.text != "", self.userEmailTxtField.text != " ", self.userEmailTxtField.text != "  ", self.userEmailTxtField.text != "   ", self.userEmailTxtField.text != "    " {
                
            postingDetails()
      
                UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
                    self.appearFeedbackWIthContactLbl.alpha = 1.0
                }, completion: nil)
                
                UIView.animate(withDuration: 2.4, delay: 2.4, options: .curveEaseInOut, animations: {
                    self.appearFeedbackWIthContactLbl.alpha = 0.0
                }, completion: nil)
            } else {
                postingDetails()
            }
            

            
            
            
//            newFeedbackRef.setValue(postToFirebase(username: self.username, feedbackFieldTxt: self.userEmailTxtField.text! as String, userContactFieldTxt: self.userEmailTxtField.text! as String, feedbackTimestamp: self.feedbackTimestamp), withCompletionBlock: { err, dbref in
            
//                if err != nil {
//                print("error happened: \(String(describing: err))")
//
//                newFeedbackRef.setValue(self.postToFirebase(username: "error", feedbackFieldTxt: "error", userContactFieldTxt: "error", feedbackTimestamp: "error"))
//
//                } else {
//                print("feedback uploaded successfully \(dbref)")
//                }
            
//            })
        
        } else {
            feedbackTxtField.shake()
        }
    }
            
            
            
//            newFeedbackRef.setValue(postToFirebase(username: self.username, feedbackFieldTxt: self.userEmailTxtField.text! as NSString, userContactFieldTxt: self.userEmailTxtField.text! as NSString, feedbackTimestamp: self.feedbackTimestamp), withCompletionBlock: { err, dbref in
//
//                    if err != nil {
//                        print("error happened: \(String(describing: err))")
//
//                        newFeedbackRef.setValue(self.postToFirebase(username: "error", feedbackFieldTxt: "error", userContactFieldTxt: "error", feedbackTimestamp: "error"))
//
//                    } else {
//                        print("feedback uploaded successfully \(dbref)")
//                    }
//                })
//
//
//        }

    
    
    
    @IBAction func RateAppClicked(_ sender: Any) {
        if let url = URL(string: "https://www.google.com/") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }
    }

    

    @IBAction func logOutPressed(_ sender: Any) {
    
//        UserDefaults.standard.set(false, forKey: "status")
//        Switcher.updateRootVC()
        
        
        do {
            try Auth.auth().signOut()
performSegue(withIdentifier: "logoutSegue", sender: self)

        } catch let err {
            print("FAILED to logout:::", err)
        }
        
}
    
}




extension UITextField {
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 8, y: self.center.y - 8))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 8, y: self.center.y + 8))
  
        self.layer.add(animation, forKey: "position")
    }
}
