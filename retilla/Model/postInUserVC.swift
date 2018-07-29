//
//  postInUserVC.swift
//  retilla
//
//  Created by satkis on 7/22/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import Foundation
import Firebase

class postInUserVC {
    private var _postStory: String?
    private var _hashtag: String?
    private var _location_city: String?
    private var _location_country: String?
    private var _lat: Double!
    private var _long: Double!
    private var _timestamp: Double!
    private var _username: String?
    
    private var _imageUrl: String?
    private var _sectionNo: Int?
    private var _postKey: String!
    private var _postRef: DatabaseReference!

    
    var postStory: String? {
        return _postStory
    }
    
    var hashtag: String? {
        return _hashtag
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    var location_city: String? {
        return _location_city
    }
    
    var location_country: String? {
        return _location_country
    }
    
    var lat: Double! {
        return _lat
    }
    
    var long: Double! {
        return _long
    }
    
    var timestamp: Double! {
        return _timestamp
    }
    
    var username: String? {
        return _username
    }
    
    
    
    
    var sectionNo: Int? {
        return _sectionNo
    }
    
    var postKey: String {
        return _postKey
    }

    
    init(postStory: String?, hashtag: String?, location_city: String!, location_country: String!, username: String?, timestamp: Double!, lat: Double!, long: Double!, imageUrl: String?, sectionNo: Int?) {
        self._postStory = postStory
        self._hashtag = hashtag
        self._location_city = location_city
        self._location_country = location_country
        self._lat = lat
        self._long = long
        self._timestamp = timestamp
        self._username = username
        
        self._imageUrl = imageUrl
        self._sectionNo = sectionNo
    }
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let postStory = dictionary["description"] as? String {
            self._postStory = postStory
        }
        
        if let hashtag = dictionary["hashtag"] as? String {
            self._hashtag = hashtag
        }
        
        if let lat = dictionary["latitude"] as? Double {
            self._lat = lat
        }
        
        if let long = dictionary["longitude"] as? Double {
            self._long = long
        }
        
        if let location_city = dictionary["location_city"] as? String {
            self._location_city = location_city
        }
        
        if let location_country = dictionary["location_country"] as? String {
            self._location_country = location_country
        }
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self._timestamp = timestamp
        }
        
        if let username = dictionary["username"] as? String {
            self._username = username
        }
        
        
        
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let sectionNo = dictionary["section"] as? Int {
            self._sectionNo = sectionNo
        }
        
        self._postRef = DataService.instance.URL_USER_CURRENT.child("posts").child(self._postKey)
        
    }
        

}
