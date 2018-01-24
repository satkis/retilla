//
//  ViewController.swift
//  retilla
//
//  Created by satkis on 1/22/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //viewDidAppear doesnt require user to login again if he did that once
        if UserDefaults.standard.value(forKey: KEY_UID) != nil {
            self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
    
    

    
    @IBAction func fbLoginPressed(_ sender: Any) {
        let facebookLogin =  FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if error != nil {
                print("FB LOGIN FAILED::: \(String(describing: error))")
            } else {
                let accessToken = FBSDKAccessToken.current().tokenString
                print("SUCCESSFULLY LOGGED IN TO FB::: \(String(describing: accessToken))")
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken!)
                Auth.auth().signIn(with: credential) { (authData, error) in
                    if error != nil {
                        print("FIREBASE LOGIN FAILED::: \(String(describing: error))")
                    } else {
                        print("USER LOGGED IN TO FIREBASE::: \(Auth.auth())")
                        
//                        let displayy = authData?.displayName as Any
//                        let emaill = authData?.email as Any
//                        let profileImgUrll = authData?.photoURL as Any
//
//                        if let username = authData?.displayName, username != "", let email = authData?.email, email != "" {
//
//                        let user = [
//                            "username": \(authData?.displayName as Any),
//                            "email": \(authData?.email as Any)
//                            //"profileImgUrl": authData?.photoURL as Any
//                            ]
//                        } else {
//                            print("wrong")
//                        }
//
//                        let user = [
//                            "username": \(authData?.displayName as Any),
//                            "email": \(authData?.email as Any)
//                            //"profileImgUrl": authData?.photoURL as Any
//                        ]
                        
                        let user = [
                            "username": "sssss",
                            "email": "dddddd",
                            "profileImgUrl": "eeeeeee"
                        ]
                        
                        DataService.instance.createFirebaseUser(uid: (authData?.uid)!, user: user as! Dictionary<String, String> )
                        //user?.uid is a unique user ID saved as KEY_UID. this authorises user into Firebase
                        UserDefaults.standard.set(authData?.uid , forKey: KEY_UID)
                        self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func emailLoginPressed(_ sender: Any) {
        if let email = emailTxt.text, email != "", let pwd = passwordTxt.text, pwd != "" {
            
            Auth.auth().signIn(withEmail: self.emailTxt.text!, password: self.passwordTxt.text!, completion: { (authData, error) in
                
                if error != nil {
                    print("ERROR::: \(error as Any)")
                    if let error = AuthErrorCode(rawValue: STATUS_ACCOUNT_NONEXIST) {
                        //create user if email and password not existing
                        Auth.auth().createUser(withEmail: self.emailTxt.text!, password: self.passwordTxt.text!, completion: { (result, error) in
                            if error != nil {
                                self.showErrorAlert(title: "smth wrong with acct creation", msg: "try later or continue  Anonymously")
                            }  else {
                                //UserDefaults.standard.set(result[KEY_UID], forKey: KEY_UID)
                                UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: KEY_UID)
                                print("USER LOGGED IN WITH ID::: \(String(describing: Auth.auth().currentUser?.uid))")
                                self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                            }
                        }
                        )} else {
                        self.showErrorAlert(title: "kitokia error", msg: "neaisku kas negerai")
                    }
                } else {
                    //login if user already exists
                    self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                }
            }
            )} else {
            self.showErrorAlert(title: "enter email or password", msg: "enter email or password")
        }
    }
    
    
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
}








