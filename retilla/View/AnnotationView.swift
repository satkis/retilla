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
                    markerTintColor = #colorLiteral(red: 0.1490196078, green: 0.7529411765, blue: 0.2509803922, alpha: 1)
                    displayPriority = .defaultHigh
                } else if annot.sectionNumber == 1 {
                    markerTintColor = #colorLiteral(red: 0.462745098, green: 0.1803921569, blue: 1, alpha: 1)
                    displayPriority = .defaultLow
                } else if annot.sectionNumber == 2 {
                    markerTintColor = #colorLiteral(red: 1, green: 0.6117647059, blue: 0.1803921569, alpha: 1)
                    displayPriority = .defaultLow
                } else if annot.sectionNumber == 3 {
                    markerTintColor = #colorLiteral(red: 1, green: 0.1803921569, blue: 0.1568627451, alpha: 1)
                    displayPriority = .defaultLow
                }
            }
        }
    }
}
