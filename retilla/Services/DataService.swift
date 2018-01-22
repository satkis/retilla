//
//  DataServices.swift
//  retilla
//
//  Created by satkis on 1/22/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import Foundation
import Firebase

let _URL_BASE = Database.database().reference(fromURL: "https://retilla-220b1.firebaseio.com/")

class DataService {
    
    static let instance = DataService()

    var URL_BASE: DatabaseReference! {
        return _URL_BASE
    }
   
    

    
}

