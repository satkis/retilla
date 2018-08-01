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
                    markerTintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                    displayPriority = .defaultLow
                } else if annot.sectionNumber == 1 {
                    markerTintColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
                    displayPriority = .defaultLow
                } else if annot.sectionNumber == 2 {
                    markerTintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                    displayPriority = .defaultLow
                } else if annot.sectionNumber == 3 {
                    markerTintColor = #colorLiteral(red: 0.9748770622, green: 0.2074409752, blue: 0.09760432108, alpha: 1)
                    displayPriority = .defaultHigh
                }
            }
        }
    }
}
