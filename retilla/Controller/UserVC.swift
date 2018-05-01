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
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postCounterLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        currentUser_DBRef = DataService.instance.URL_USER_CURRENT
        
        currentUser_DBRef.observeSingleEvent(of: .value) { (snapshot) in
            
           let snap = snapshot.value as? NSDictionary
            print("snap::: \(String(describing: snap))")
            let email = snap?["email"] as? String
            let firstName = snap?["first_name"] as? String
            //let lastName = snap?["last_name"] as? String
//            let fullName = snap?["name"] as? String

            if firstName != nil {
                self.userNameLbl.text = firstName
            } else if firstName == nil || email == "Anonymous" {
                self.userNameLbl.text = "Anonymous"
            } else if email != "" {
                //FIX cut name up till @
                self.userNameLbl.text = email
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
    
}
