//
//  Post.swift
//  retilla
//
//  Created by satkis on 1/25/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import Foundation

class Post {
    
    private var _postStory: String?
    private var _hashtag: String?
    private var _coordinatesGps: Double!
    private var _imageUrl: String?
    private var _likes: Int?
    private var _username: String!
    private var _postKey: String!
    private var _sectionNumber: Int!
    
var postStory: String? {
    return _postStory
}
    
    var hashtag: String? {
        return _hashtag
    }
    
    var coordinatesGps: Double {
        return _coordinatesGps
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    var likes: Int? {
        return _likes
    }
    
    var username: String {
        return _username
    }
    
    var sectionNumber: Int {
        return _sectionNumber
    }
    

    init(postStory: String?, hashtag: String?, imageUrl: String?, username: String) {
        self._postStory = postStory
        self._hashtag = hashtag
        self._imageUrl = imageUrl
        self._username = username
        self._sectionNumber = sectionNumber
    }
    
    //calling this when downloading data from Firebase
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let likes = dictionary["likes"] as? Int {
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
        if let sectionNumber = dictionary["sectionNr"] as? Int {
            self._sectionNumber = sectionNumber
        }
    }
    
    
    
    

}
