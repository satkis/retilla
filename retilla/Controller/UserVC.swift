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

    var DBRef: DatabaseReference!
    var post: Post!
    var user: User!
    
    @IBOutlet weak var postCounterLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        DBRef = DataService.instance.URL_USER_CURRENT
        
        DBRef.child("posts").observeSingleEvent(of: .value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
               // self.postCounterLbl.text = String(snapshots.count)
                self.postCounterLbl.text = self.user.name
                
            }
        }
        
        
        
//        DBRef.observeSingleEvent(of: .value) { (snapshot) in
//            if let snapshots = snapshot.children.
//        }
        
    }
    



}
