//
//  Annotations.swift
//  retilla
//
//  Created by satkis on 2/12/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class Annotations: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var reactions: Int?
    var imageUrl: String?
    var postStory: String?
    var hashtag: String?
    var sectionNumber: Int?
    var location: String?
    var countryLocation: String?
    var timeStamp: Double!
    var userName: String!
    
    init(coordinate: CLLocationCoordinate2D, reactions: Int?, imageUrl: String?, postStory: String?, hashtag: String?, sectionNumber: Int?, location: String?, countryLocation: String?, timeStamp: Double!, userName: String?) {
        self.coordinate = coordinate
        self.reactions = reactions
        self.imageUrl = imageUrl
        self.postStory = postStory
        self.hashtag = hashtag
        self.sectionNumber = sectionNumber
        self.location = location
        self.countryLocation = countryLocation
        self.timeStamp = timeStamp
        self.userName = userName
        
        super.init()
    }
    
    var subtitle: String? {
        return ""
    }
    var title: String? {
        return ""
    }

    
}
