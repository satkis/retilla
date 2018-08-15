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
import FBSDKLoginKit

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    

    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var dict: NSDictionary!
    var currentUser_DBRef: DatabaseReference!
    var currentUser = UserDefaults.standard.value(forKey: KEY_UID)
    var fbAccessToken = AccessToken.self
    var user: User!
    
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
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
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
//                self.fbAccessToken = AccessToken.self
                //https://firebase.google.com/docs/auth/ios/account-linking
                let credential = FacebookAuthProvider.credential(withAccessToken: token.authenticationToken)
                Auth.auth().signIn(with: credential, completion: { (authData, error) in
                    if error != nil {
                        print("FIREBASE LOGIN FAILED::: \(String(describing: error))")
                    } else {
                        print("USER LOGGED IN TO FIREBASE::: \(Auth.auth())")
                        
                        // guard for user id
                        guard let uid = authData?.uid else {
                            return }
                        // create a child reference - uid will let us wrap each users data in a unique user id for later reference
                        let usersReference = DataService.instance.URL_USERS.child(uid)
                        let graphPath = "me"
                        let parameters = ["fields": "name, first_name, last_name, email"]
                        let graphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: parameters)
                        graphRequest?.start(completionHandler: { (connection, result, error) in
                            
                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                                print("resulresult", result as Any)
                                let data:[String:AnyObject] = result as! [String : AnyObject]
//                                let userName : NSString? = data["name"]! as? NSString
                                let firstName : NSString? = data["first_name"]! as? NSString
                                //let lastName : NSString? = data["last_name"]! as? NSString
                                let email : NSString? = data["email"]! as? NSString
                                guard let userd = authData?.uid else { return }
                                let user = ["first_name": firstName as Any, "email": email as Any]
                                print("USER IDDD UID::: \(String(describing: authData?.uid)))")
                                
                                usersReference.updateChildValues(user, withCompletionBlock: { (err, ref) in
                                    if err != nil {
                                        DataService.instance.createFirebaseUser(uid: userd, user: user as Dictionary<String, AnyObject>)
                                        UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: KEY_UID)
                                        print("there is error_FBLogin", err!)
                                        return
                                    }
                                    print("Save the user successfully into Firebase database")
                                    UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: KEY_UID)
                                    self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)

                                })
                            }
                        })
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
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let err = error {
            print("failed to log in into Google", err)
        } else {
            print("singed in with GOOGLE successfully", user)
            guard let googleIDToken = user.authentication.idToken else { return }
            guard let googleAccessToken = user.authentication.accessToken else { return }
            let credentials = GoogleAuthProvider.credential(withIDToken: googleIDToken, accessToken: googleAccessToken)
            let userGoogleEmail = user.profile.email
            let userGoogleGivenName = user.profile.givenName
//            let userGoogleName = user.profile.name gives users full name
            print("userGoogleEmail", userGoogleEmail as Any)
         

            Auth.auth().signIn(with: credentials) { (user, error) in
                if let err = error {
                    print("failed to create Firebase user with Google acct", err)
                    return
                } else {
                    guard let usere = user?.uid else { return }
                    // create a child reference - uid will let us wrap each users data in a unique user id for later reference
                    let usersReference = DataService.instance.URL_USERS.child(usere)
                    let user = ["first_name": userGoogleGivenName as Any, "email": userGoogleEmail as Any]
                    
                    usersReference.updateChildValues(user, withCompletionBlock: { (err, ref) in
                        if err != nil {
                            DataService.instance.createFirebaseUser(uid: usere, user: user as Dictionary<String, AnyObject>)
                            UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: KEY_UID)
                            print("there is error_GoogleLogin", err!)
                            return
                        }
                        print("Save the user successfully into Firebase database")
                        UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: KEY_UID)
                        self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                        
                    })
                }
            }
        }
    }
            
            
            
            
            //                    guard let uid = user?.uid else { return }
                    
//                    print("successfully logged into FIrebase with Google", user?.uid as Any)
                    //self.currentUser = Auth.auth().currentUser
//                    UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: KEY_UID)
//                    print("useruseruser:::", Auth.auth().currentUser?.uid as Any)
//                    let user = ["email": userGoogleEmail]
//                    DataService.instance.createFirebaseUser(uid: (Auth.auth().currentUser?.uid)!, user: user as Dictionary<String, AnyObject>)
//
//                    self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
//                    print("logged in and sent to FeedVC after Google login")
                    
                    
//                    self.currentUser = Auth.auth().currentUser
//                    UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: KEY_UID)
//                    let user = ["email": "lalala" ]
//                    DataService.instance.createFirebaseUser(uid: (Auth.auth().currentUser?.uid)!, user: user as Dictionary<String, AnyObject>)
//                    self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
//                    print("logged in okk:::")
//                }
//            }
//        }
//    }

    
    
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








