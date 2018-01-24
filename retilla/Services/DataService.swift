//
//  DataServices.swift
//  retilla
//
//  Created by satkis on 1/22/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import Foundation
import Firebase

let URL_GENERAL = Database.database().reference(fromURL: "https://retilla-220b1.firebaseio.com/")

class DataService {
    
    static let instance = DataService()
    
    private var _REF_BASE = URL_GENERAL
    private var _REF_POSTS = URL_GENERAL.child("posts")
    private var _REF_USERS = URL_GENERAL.child("users")

    
    // make publicly available
    var URL_BASE: DatabaseReference! {
        return _REF_BASE
    }
    
    var URL_POSTS: DatabaseReference! {
        return _REF_POSTS
    }
   
    var URL_USERS: DatabaseReference! {
        return _REF_USERS
    }

    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        URL_USERS.child(uid).setValue(user)
    }
    
    
}

