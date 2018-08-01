//
//  CLusterAnnotation.swift
//  retilla
//
//  Created by satkis on 8/2/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import Foundation
import MapKit

open class MKCluserAnnotation : NSObject, MKAnnotation, MKClusterAnnotation {
    
    open var title: String?
    open var subtitle: String?
    
    open var memberAnnotations: [MKAnnotation] { get }
    public init(memberAnnotation: [MKAnnotation])
}
