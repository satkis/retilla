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
    
    var dict: NSDictionary!
    
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
                        
                        let graphPath = "me"
                        
                        let parameters = ["fields": "name, first_name, last_name, timezone, picture, email"]
                        
                        let graphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: parameters)
                        
                        graphRequest?.start(completionHandler: { (connection, result, error) in
                            
                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                                print(result)
                                let data:[String:AnyObject] = result as! [String : AnyObject]
                                
                                let userName : NSString? = data["name"]! as? NSString
                                let firstName : NSString? = data["first_name"]! as? NSString
                                let lastName : NSString? = data["last_name"]! as? NSString
                                let timeZone : NSInteger? = data["timezone"]! as? NSInteger
                                //url extract doenst work
                                let profileImgUrl : NSString? = data["picture"]! as? NSString
                                let email : NSString? = data["email"]! as? NSString
                                
                                let user = ["name": userName as Any, "first_name": firstName as Any, "last_name": lastName as Any, "timezone": timeZone as Any, "picture": profileImgUrl as Any, "email": email as Any]
                                
                                DataService.instance.createFirebaseUser(uid: (authData?.uid)!, user: user as Dictionary<String, AnyObject>)
                                print("USER IDDD UID::: \(authData?.uid))")
                                
                                
                                self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                                
                            }
                        })
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
                                
//                                let data:[String:AnyObject] = result as! [String : AnyObject]
//
//                                let userName : NSString? = data["email"]! as? NSString
                                let user = ["email": self.emailTxt.text]
                                
                                DataService.instance.createFirebaseUser(uid: (result?.uid)!, user: user as Dictionary<String, AnyObject>)
                                
                                
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
    
    
    @IBAction func loginAnonymouslyTapped(_ sender: Any) {
        Auth.auth().signInAnonymously { (user, error) in
            if error == nil {
                // successfully sign in anonymously
                
                UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: KEY_UID)
                let user = ["name": "Anonymous"]
                DataService.instance.createFirebaseUser(uid: (Auth.auth().currentUser?.uid)!, user: user as Dictionary<String, AnyObject>)
                self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                print("anonymous user: \((Auth.auth().currentUser?.uid)!)")
            }
        }
    }
    
    
    
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    

    
    
    
    
    
    
    
    
    
}








