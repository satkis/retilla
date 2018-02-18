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
//    var identifier: String?
    var title: String?
    var locationName: String?
    
    
    init(coordinate: CLLocationCoordinate2D, title: String?, locationName: String?) {
        self.coordinate = coordinate
        self.title = title
        self.locationName = locationName
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
}
