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
    var feedbackFieldTxt: NSString! = "no no no"
    var userContactFieldTxt: NSString! = "no contact"
    var username: NSString! = "user nmm"
    var feedbackTimestamp: NSString! = "smth wrongg"
    var newFeedbackKey = DataService.instance.URL_POSTS.childByAutoId().key
//    var userLocationCountry: String? = "no country"
//    var userLocationCity: String? =  "no cityy"
    
//    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var feedbackTxtField: UITextField!
    @IBOutlet weak var userEmailTxtField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    
    func postToFirebase(username: NSString!, feedbackFieldTxt: NSString!, userContactFieldTxt: NSString!, feedbackTimestamp: NSString!) {
        
        let feedbackTimestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        
        let username = "ddd"
        
        let feedback: Dictionary<String, Any> = [
            "feedback_Time": feedbackTimestamp as NSString,
            "username": username as NSString,
            "user_typed_contacts": userEmailTxtField!.text! as NSString,
            "feedback": feedbackTxtField.text! as NSString
        ]
        
        let firebaseFeedback = DataService.instance.URL_FEEDBACK.child(newFeedbackKey)
        firebaseFeedback.setValue(feedback)
    }

    
    @IBAction func sendFeedbackPressed(_ sender: Any) {
        if self.feedbackTxtField.text != "" || (self.feedbackTxtField.text?.count)! > 5 {
            
            let newFeedbackRef = DataService.instance.URL_FEEDBACK.childByAutoId()
            let newFeedbackKey = newFeedbackRef.key
            self.newFeedbackKey = newFeedbackKey

            newFeedbackRef.setValue(postToFirebase(username: self.username, feedbackFieldTxt: self.userEmailTxtField.text! as NSString, userContactFieldTxt: self.userEmailTxtField.text! as NSString, feedbackTimestamp: self.feedbackTimestamp), withCompletionBlock: { err, dbref in
            
                if err != nil {
                print("error happened: \(String(describing: err))")
                
                newFeedbackRef.setValue(self.postToFirebase(username: "error", feedbackFieldTxt: "error", userContactFieldTxt: "error", feedbackTimestamp: "error"))
                
                } else {
                print("feedback uploaded successfully \(dbref)")
                }
            
            })
        } else {
            sendButton.isUserInteractionEnabled = false
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
    }
    
}
