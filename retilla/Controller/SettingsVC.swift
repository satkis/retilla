//
//  SettingsVC.swift
//  retilla
//
//  Created by satkis on 5/13/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit
import Firebase


class SettingsVC: UIViewController, UITextViewDelegate {

    var currentUser = UserDefaults.standard.value(forKey: KEY_UID)
    var user: User!
    var feedbackFieldTxt: String! = "no no no"
    var userContactFieldTxt: String! = "no contact"
    var username: String! = "user nmm"
    var feedbackTimestamp: String! = "smth wrongg"
    var newFeedbackKey = DataService.instance.URL_POSTS.childByAutoId().key
    var placeholderLabel: UILabel!
    
//    var userLocationCountry: String? = "no country"
//    var userLocationCity: String? =  "no cityy"
    
//    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var feedbackTxtField: UITextField!
    @IBOutlet weak var feedbackTxtView: UITextView!
    
    @IBOutlet weak var userEmailTxtField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var appearFeedbackLbl: UILabel!
    @IBOutlet weak var appearFeedbackWIthContactLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appearFeedbackLbl.alpha = 0
        appearFeedbackWIthContactLbl.alpha = 0
        
        feedbackTxtView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "share feedback here"
        placeholderLabel.font = UIFont.systemFont(ofSize: (feedbackTxtView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        feedbackTxtView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (feedbackTxtView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !feedbackTxtView.text.isEmpty
        
        
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
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    
    func postToFirebase(username: String!, feedbackFieldTxt: String!, userContactFieldTxt: String!, feedbackTimestamp: String!) {
        
        let feedbackTimestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        
        let username = "ddd"
        
        let feedback: Dictionary<String, Any> = [
            "feedback_Time": feedbackTimestamp as Any,
            "username": username as Any,
            "user_typed_contacts": userEmailTxtField!.text! as Any,
            "feedback": feedbackTxtView.text! as Any
        ]
        
        let firebaseFeedback = DataService.instance.URL_FEEDBACK.child(newFeedbackKey)
        firebaseFeedback.setValue(feedback)
        feedbackTxtView.text = ""
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
        if self.feedbackTxtView.text != "", self.feedbackTxtView.text != " ", self.feedbackTxtView.text != "  ", self.feedbackTxtView.text != "   ", self.feedbackTxtView.text != "    " {
            if self.userEmailTxtField.text != "", self.userEmailTxtField.text != " ", self.userEmailTxtField.text != "  ", self.userEmailTxtField.text != "   ", self.userEmailTxtField.text != "    " {
                
                postingDetails()
                
                //dismiss keyboard
                self.view.endEditing(true)
                
                UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
                    self.appearFeedbackWIthContactLbl.alpha = 1.0
                }, completion: nil)
                
                UIView.animate(withDuration: 2.4, delay: 2.4, options: .curveEaseInOut, animations: {
                    self.appearFeedbackWIthContactLbl.alpha = 0.0
                }, completion: nil)
            } else {
                postingDetails()
                //dismiss keyboard
                self.view.endEditing(true)
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
            feedbackTxtView.shake()
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

       //https://www.youtube.com/watch?v=lvz0cPkIxzM partly used logic from this link
        
        UserDefaults.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
        
        let initialVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = initialVC
        
//        if UserDefaults.standard.value(forKey: "appFirstTImeOpened") == nil {
//            UserDefaults.standard.setValue(true, forKey: "appFirstTImeOpened")
//
//            do {
//                try Auth.auth().signOut()
//            } catch {
//
//            }
//
//        }
//        performSegue(withIdentifier: SEGUE_LOGOUT_TAPPED, sender: nil)
        
//        try! Auth.auth().signOut()
//        UserDefaults.standard.removeObject(forKey: KEY_UID)
//
//        currentUser = nil
//        //UserDefaults.standard.synchronize()
//        performSegue(withIdentifier: SEGUE_LOGOUT_TAPPED, sender: nil)
        
        //print("USERID_SETTINGSVC", DataService.instance.URL_USER_CURRENT.key)
        print("USERID_SETTINGSVCC", currentUser as Any)
        //        UserDefaults.standard.set(false, forKey: "status")
        //        Switcher.updateRootVC()
        
        
        
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

extension UITextView {
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
