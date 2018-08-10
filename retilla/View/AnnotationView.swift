//
//  AnnotationView.swift
//  retilla
//
//  Created by satkis on 8/2/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import Foundation
import MapKit

class AnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            if let annot = newValue as? Annotations {
                clusteringIdentifier = "reduce"
                if annot.sectionNumber == 0 {
//                    markerTintColor = #colorLiteral(red: 0.9748770622, green: 0.2074409752, blue: 0.09760432108, alpha: 1)
                    markerTintColor = UIColor.green
                    displayPriority = .defaultHigh
                } else if annot.sectionNumber == 1 {
                    markerTintColor = UIColor.blue
                    displayPriority = .defaultLow
                } else if annot.sectionNumber == 2 {
                    markerTintColor = UIColor.orange
                    displayPriority = .defaultLow
                } else if annot.sectionNumber == 3 {
                    markerTintColor = UIColor.red
                    displayPriority = .defaultLow
                }
            }
        }
    }
}
