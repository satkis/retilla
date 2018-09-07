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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func animateIn() {
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.popUpView.alpha = 1
            self.popUpView.transform = CGAffineTransform.identity
        }
    }
    
    func resetPassword(email: String) {
        if let email = emailField.text, email != "", email.contains("@"), email.contains(".") {
  
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                print("pasword was reset successfully")
                self.emailField.text = ""
                self.showErrorAlert(title: "Successful reset!", msg: "Check your email \(email)")
                
            } else {
                self.showErrorAlert(title: "Email doesn't exist", msg: "Register as a new user or login with Google or Facebook")
            }
            } 
        } else {
            self.showErrorAlert(title: "invalid email format", msg: "")
        }
    }
    
    @IBAction func resterPwdPressed(_ sender: Any) {
        resetPassword(email: emailField.text!)
        
    }


    
    @IBAction func closeBttn(_ sender: Any) {
                    dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func closeResetWindow(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    

    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }


}
