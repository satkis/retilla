//
//  SettingsVC.swift
//  retilla
//
//  Created by satkis on 5/13/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn


class SettingsVC: UIViewController, UITextViewDelegate {

    var currentUser = UserDefaults.standard.value(forKey: KEY_UID)
    var user: User!
    var feedbackFieldTxt: String! = "no no no"
    var userContactFieldTxt: String! = "no contact"
    var username: String! = "user nmm"
    var feedbackTimestamp: String! = "smth wrongg"
    var newFeedbackKey = DataService.instance.URL_POSTS.childByAutoId().key
    var placeholderLabel: UILabel!
    
    let message = "Hey, check out wasteBud app. Available on the AppStore: https://itunes.apple.com/us/app/wastebud/id1434517217?ls=1&mt=8"

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
        
  
    }
    

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
   
        
        } else {
            feedbackTxtView.shake()
        }
    }
 
    
    
    @IBAction func RateAppClicked(_ sender: Any) {
        let appID = "1434517217"
        let urlStr = "https://itunes.apple.com/us/app/wastebud/id\(appID)?ls=1&mt=8" // (Option 1) Open App Page
        //        let urlStr = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)" // (Option 2) Open App Review Tab

        if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }

    }
    
    @IBAction func shareApp(_ sender: UIButton) {
        
        guard let image = UIImage(named: "logo") else { return }
        
        let activityController = UIActivityViewController(activityItems: [message, image], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = { (nil, completed, _, error) in
            if completed {
                print("completedd")
            } else {
                print("cancelled")
            }
        }
        activityController.popoverPresentationController?.sourceView = sender
        present(activityController, animated: true) {
            print("presented")
        }
        
    }
    
 
    

  
    @IBAction func logOutPressed(_ sender: Any) {

       //https://www.youtube.com/watch?v=lvz0cPkIxzM partly used logic from this link
        try! GIDSignIn.sharedInstance().signOut()
        UserDefaults.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
        
        let initialVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = initialVC
     
        print("USERID_SETTINGSVCC", currentUser as Any)

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
