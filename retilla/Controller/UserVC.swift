//
//  UserVC.swift
//  retilla
//
//  Created by satkis on 4/30/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit
import Firebase

class UserVC: UIViewController {

    var currentUser_DBRef: DatabaseReference!
    var post: Post!
    var user: User!
    
    var emaii: String!
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postCounterLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupNavigationBarItems()
        
        currentUser_DBRef = DataService.instance.URL_USER_CURRENT
        
        currentUser_DBRef.observeSingleEvent(of: .value) { (snapshot) in
            
           let snap = snapshot.value as? Dictionary<String, AnyObject>
            print("snap::: \(String(describing: snap))")
            
            let key = snapshot.key
            let user = User(userKey: key, dictionary: snap!)
            
            self.emaii = user.email
            
            let emaill = user.email
            print("emaill ll \(emaill)")
            
            let email = snap?["email"] as? String
            let firstName = snap?["first_name"] as? String
            //let lastName = snap?["last_name"] as? String
//            let fullName = snap?["name"] as? String

            if firstName != nil {
                self.userNameLbl.text = firstName
            } else if firstName == nil || email != "" {
                self.userNameLbl.text = email
            } else if email == "" {
                //FIX cut name up till @
                self.userNameLbl.text = "Anonymous"
            } else {
                self.userNameLbl.text = "User name not found"
            }
        }
        
    
        currentUser_DBRef.child("posts").observeSingleEvent(of: .value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                self.postCounterLbl.text = String(snapshots.count)
            }
        }

    }
    
   private func setupNavigationBarItems() {
        print("setupNavig FUnc is called")

        let userIcon = UIImageView(image: #imageLiteral(resourceName: "userIcon"))
        userIcon.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        userIcon.contentMode = .scaleAspectFit
        navigationItem.titleView = userIcon
    
    let settingsButton = UIButton(type: .infoLight)
    settingsButton.setImage(#imageLiteral(resourceName: "settingsIcon").withRenderingMode(.alwaysOriginal), for: .normal)
    settingsButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
    settingsButton.contentMode = .scaleToFill
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingsButton)
    settingsButton.addTarget(self, action: #selector(settingsClicked(_ :)), for: .touchUpInside)
    self.view.addSubview(settingsButton)
    }
    
    @objc func settingsClicked(_ : UIButton) {
        self.performSegue(withIdentifier: SEGUE_TOSETTINGSVC, sender: self)
    }
    
//    @IBAction func settingsButton(_ sender: UIButton) {
//        self.performSegue(withIdentifier: SEGUE_TOSETTINGSVC, sender: self)
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == SEGUE_TOSETTINGSVC {
//            if let destination = segue.destination as? SettingsVC {
//                perform
//            }
//        }
//    }
    

    
    
}
