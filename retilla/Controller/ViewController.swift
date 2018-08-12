//
//  ViewController.swift
//  retilla
//
//  Created by satkis on 1/22/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import Firebase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {

    

    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var dict: NSDictionary!
    var currentUser_DBRef: DatabaseReference!
    var currentUser = UserDefaults.standard.value(forKey: KEY_UID)
    var fbAccessToken = AccessToken.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        activityIndicator.isHidden = true
        if UserDefaults.standard.value(forKey: KEY_UID) != nil {
            self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
        }
        
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 30, y: 350, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        activityIndicator.isHidden = true
//        viewDidAppear doesnt require user to login again if he did that once
        
        if UserDefaults.standard.value(forKey: KEY_UID) != nil {
            self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
        }
        
       
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    @IBAction func facebookLoginTppd(_ sender: UITapGestureRecognizer) {
       
        let fbLoginMnrg = LoginManager()
        fbLoginMnrg.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .cancelled:
                print("user fb login cancelled:::")
            case .failed(_):
                print("user fb login failed:::")
            case .success(let grantedPermissions, let declinedPermissions, let token):
                print("gantedPermissions:::", grantedPermissions)
                print("declinedPermissions:::", declinedPermissions)
                self.fbAccessToken = AccessToken.self
                //https://firebase.google.com/docs/auth/ios/account-linking
                let credential = FacebookAuthProvider.credential(withAccessToken: token.authenticationToken)
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    if let error = error {
                        print("error it is:::", error)
                        return
                    } else {
                        self.currentUser = Auth.auth().currentUser
                        UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: KEY_UID)
                        self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                        print("logged in okk:::")
                    }
                })
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
                            } else {
                                //https://medium.com/@paul.allies/ios-swift4-login-logout-branching-4cdbc1f51e2c
                                // Switcher.updateRootVC()

                                UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: KEY_UID)
                                
                                let user = ["email": self.emailTxt.text]
                                DataService.instance.createFirebaseUser(uid: (Auth.auth().currentUser?.uid)!, user: user as Dictionary<String, AnyObject>)
                                print("USER SIGNED UP WITH ID::: \(String(describing: Auth.auth().currentUser?.uid))")
                                self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                            }
                        }
                        )} else {
                        self.showErrorAlert(title: "kitokia error", msg: "neaisku kas negerai")
                    }
                } else {
                    //login if user already exists
                    Auth.auth().signIn(withEmail: self.emailTxt.text!, password: self.passwordTxt.text!, completion: nil)
                    UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: KEY_UID)
                    self.currentUser = UserDefaults.standard.value(forKey: KEY_UID)
                    self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                }
            }
            )} else {
            self.showErrorAlert(title: "enter email or password", msg: "enter email or password")
        }
    }
    
    

    
    
    @IBAction func googleLoginTapped(_ sender: UITapGestureRecognizer) {
        
    }
    
    

    
    
    @IBAction func loginAnonymouslyTapped(_ sender: Any) {
        Auth.auth().signInAnonymously { (user, error) in
            if error == nil {
                // successfully sign in anonymously
                
                UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: KEY_UID)
                let user = ["email": "Anonymous\(arc4random())"]
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








