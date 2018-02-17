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
    dynamic var coordinate: CLLocationCoordinate2D
    var identifier: String?
    
    init(coordinate: CLLocationCoordinate2D, identifier: String) {
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
    
}
