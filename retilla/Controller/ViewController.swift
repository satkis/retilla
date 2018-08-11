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


class ViewController: UIViewController {

    
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

                
                
                
                
                
                
                        
                        
                        
                        
    
    
//    @IBAction func facebookLoginTppd(_ sender: UITapGestureRecognizer) {
//        let facebookLogin =  FBSDKLoginManager()
//        facebookLogin.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
//            if error != nil {
//                print("FB LOGIN FAILED::: \(String(describing: error))")
//
//            } else if (result?.isCancelled)! {
//                print("cancel:::")
//                return
//            } else {
//
//                self.activityIndicator.isHidden = false
//
//                let accessToken = FBSDKAccessToken.current().tokenString
//                print("SUCCESSFULLY LOGGED IN TO FB::: \(String(describing: accessToken))")
//                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken!)
//
//                Auth.auth().signIn(with: credential) { (authData, error) in
//                    if error != nil {
//                        print("FIREBASE LOGIN FAILED::: \(error?.localizedDescription as Any)")
//                        print("error accountExistsWithDifferentCredential:::", AuthErrorCode.accountExistsWithDifferentCredential)
//                    } else {
//                        print("error error error :::", error?.localizedDescription as Any)
//
//
//                                                print("USER LOGGED IN TO FIREBASE::: \(Auth.auth())")
//
//                                                // adding a reference to our firebase database
//                                                let ref = Database.database().reference(fromURL: "https://retilla-220b1.firebaseio.com/")
//                                                // guard for user id
//                                                guard let uid = authData?.uid else { return }
//
//                                                // create a child reference - uid will let us wrap each users data in a unique user id for later reference
//                                                let usersReference = ref.child("users").child(uid)
//
//                                                let graphPath = "me"
//
//                                                let parameters = ["fields": "name, first_name, last_name, picture, email"]
//
//                                                let graphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: parameters)
//
//                                                graphRequest?.start(completionHandler: { (connection, result, error) in
//                                                   // let fbloginresult : FBSDKLoginManagerLoginResult = result! as! FBSDKLoginManagerLoginResult
//                                                    if let error = error {
//                                                        print("error FB LOGINN::", error.localizedDescription)
//                                                    } else {
//                                                        print("result FB login", result)
//                                                        let data:[String:AnyObject] = result as! [String : AnyObject]
//
//                                                        let userName : NSString? = data["name"]! as? NSString
//                                                        let firstName : NSString? = data["first_name"]! as? NSString
//                                                        let lastName : NSString? = data["last_name"]! as? NSString
//                                                        //let timeZone : NSInteger? = data["timezone"]! as? NSInteger
//                                                        //url extract doenst work
//                                                        let profileImgUrl : NSString? = data["picture"]! as? NSString
//                                                        let email : NSString? = data["email"]! as? NSString
//
//                                                        let user = ["name": userName as Any, "first_name": firstName as Any, "last_name": lastName as Any, "picture": profileImgUrl as Any, "email": email as Any]
//                                                        Auth.auth().signIn(with: credential, completion: nil)
//                                                        UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: KEY_UID)
//
//                                                        DataService.instance.createFirebaseUser(uid: (authData?.uid)!, user: user as Dictionary<String, AnyObject>)
//                                                        print("USER IDDD UID::: \(String(describing: authData?.uid)))")
//
//                                                        usersReference.updateChildValues(user, withCompletionBlock: { (err, ref) in
//                                                            if err != nil {
//                                                                print(err!)
//                                                                return
//                                                            }
//                                                            print("Save the user successfully into Firebase database")
//
//                                                            self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
//
//                                                        })
//                                                    }
//                                                })
//                    }
//                }
//            }
//        }
//        self.activityIndicator.isHidden = true
//    }

    
    
    
    
    
    
    
    
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








