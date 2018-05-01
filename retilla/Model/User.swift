//
//  User.swift
//  retilla
//
//  Created by satkis on 5/1/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import Foundation
import Firebase


class User {
    private var _userRef: DatabaseReference!
    private var _userKey: String!
    
    private var _email: String!
    private var _first_name: String?
    private var _last_name: String?
    private var _name: String?
    
    var userKey: String {
        return _userKey
    }
    
    var email: String {
        return _email
    }
    
    var first_name: String? {
        return _first_name
    }
    
    var last_name: String? {
        return _last_name
    }
    
    var name: String? {
        return _name
    }
    
    init(email: String, first_name: String?, last_name: String?, name: String?) {
        self._email = email
        self._first_name = first_name
        self._last_name = last_name
        self._name = name
    }
    
    init(userKey: String, dictionary: Dictionary<String, AnyObject>) {
        
        self._userKey = userKey
        
        if let email = dictionary["email"] as? String {
            self._email = email
        }
        
        if let firstName = dictionary["first_name"] as? String {
            self._first_name = firstName
        }
        
        if let lastName = dictionary["last_name"] as? String {
            self._last_name = lastName
        }
        
        if let name = dictionary["name"] as? String {
            self._name = name
        }
        
        self._userRef = DataService.instance.URL_USER_CURRENT
    }
}






