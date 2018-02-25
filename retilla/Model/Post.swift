//
//  Post.swift
//  retilla
//
//  Created by satkis on 1/25/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _postStory: String?
    private var _hashtag: String?
    private var _coordinatesGps: String!
    private var _imageUrl: String?
    private var _likes: Int! = 0
    private var _username: String?
    private var _postKey: String!
    private var _sectionNumber: Int?
    private var _location: String?
    private var _lat: Double!
    private var _long: Double!
    private var _timestamp: String!
    private var _postRef: DatabaseReference!
    
    var postStory: String? {
        return _postStory
    }
    
    var hashtag: String? {
        return _hashtag
    }
    
    var coordinatesGps: String! {
        return _coordinatesGps
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    var likes: Int! {
        return _likes
    }
    
    var username: String? {
        return _username
    }
    
    var sectionNumber: Int? {
        return _sectionNumber
    }
    
    var postKey: String {
        return _postKey
    }
    
    var location: String? {
        return _location
    }
    
    var lat: Double! {
        return _lat
    }
    
    var long: Double! {
        return _long
    }
    
    var timestamp: String! {
        return _timestamp
    }
    
    

    init(postStory: String?, hashtag: String?, imageUrl: String?, username: String?, postCoordinates: String!, location: String!, timestamp: String!, lat: Double!, long: Double!, likes: Int!) {
        self._postStory = postStory
        self._hashtag = hashtag
        self._imageUrl = imageUrl
        self._username = username
        self._sectionNumber = sectionNumber
        self._coordinatesGps = coordinatesGps
        self._location = location
        self._lat = lat
        self._long = long
        self._timestamp = timestamp
        self._likes = likes
    }
    
    //calling this when downloading data from Firebase
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let likes = dictionary["reactions"] as? Int {
            self._likes = likes
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let postStory = dictionary["description"] as? String {
            self._postStory = postStory
        }
        
        if let hashtag = dictionary["hashtag"] as? String {
            self._hashtag = hashtag
        }
        if let sectionNumber = dictionary["section"] as? Int {
            self._sectionNumber = sectionNumber
        }
        
        if let postCoordinates = dictionary["coordinates"] as? String {
            self._coordinatesGps = postCoordinates
        }
        
        if let lat = dictionary["latitude"] as? Double {
            self._lat = lat
        }
        
        if let long = dictionary["longitude"] as? Double {
            self._long = long
        }
        
        if let location = dictionary["location"] as? String {
            self._location = location
        }
        
        if let timestamp = dictionary["timestamp"] as? String {
            self._timestamp = timestamp
        }
        
        self._postRef = DataService.instance.URL_POSTS.child(self._postKey)
    }
    
    func adjustReactions(addReaction: Bool) {
        if addReaction {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        
        _postRef.child("reactions").setValue(_likes)
    }
    
    
}
