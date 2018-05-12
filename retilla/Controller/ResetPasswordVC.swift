//
//  ResetPasswordVC.swift
//  retilla
//
//  Created by satkis on 5/1/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordVC: UIViewController {

    let mainVC = ViewController()

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var emailField: UITextField!
    

    
    var effect: UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        animateIn()
        
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        
    }
    
    
    func animateIn() {
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.popUpView.alpha = 1
            self.popUpView.transform = CGAffineTransform.identity
        }
    }
    
    func resetPassword(email: String) {
        if let email = emailField.text, email != "" || email.contains("@") || email.contains(".") {
  
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                print("pasword was reset successfully")
            } else {
                self.mainVC.showErrorAlert(title: "something went wrong", msg: "check your email or smth")
            }
            }
        }
    }
    
    
    @IBAction func closePopUP(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resterPwdPressed(_ sender: Any) {
        resetPassword(email: emailField.text!)
    }
    


}
