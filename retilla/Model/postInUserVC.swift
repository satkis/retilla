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
    private var _imageUrl: String?
    private var _sectionNo: Int?
    private var _postKey: String!
    private var _postRef: DatabaseReference!

var imageUrl: String? {
    return _imageUrl
}

var sectionNo: Int? {
    return _sectionNo
}
    
var postKey: String {
    return _postKey
}

    
    init(imageUrl: String?, sectionNo: Int?) {
        self._imageUrl = imageUrl
        self._sectionNo = sectionNo
    }
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let sectionNo = dictionary["section"] as? Int {
            self._sectionNo = sectionNo
        }
        
        self._postRef = DataService.instance.URL_USER_CURRENT.child("posts").child(self._postKey)
        
    }
        

}
