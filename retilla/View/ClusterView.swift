//
//  ClusterView.swift
//  retilla
//
//  Created by satkis on 8/2/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import Foundation
import MapKit

class ClusterView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultHigh
        collisionMode = .circle
        centerOffset = CGPoint(x: 10, y: -10) //offset center point to animate beter with marker annotations
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            if let cluster = newValue as? MKClusterAnnotation {
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
                let count = cluster.memberAnnotations.count
                
                let reuse = cluster.memberAnnotations.filter { (member) -> Bool in
                    return (member as! Annotations).sectionNumber == 0
                    }.count
                
//                let recycle = cluster.memberAnnotations.filter { (member) -> Bool in
//                    return (member as! Annotations).sectionNumber == 1
//                    }.count
//
//                let reduce = cluster.memberAnnotations.filter { (member) -> Bool in
//                    return (member as! Annotations).sectionNumber == 2
//                    }.count
//
//                let pollution = cluster.memberAnnotations.filter { (member) -> Bool in
//                    return (member as! Annotations).sectionNumber == 3
//                    }.count
                
                image = renderer.image { _ in
                    //fill full circle with REDUCE[0] color
                    UIColor.init(cgColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).setFill()
                    UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()
                    
                    //fill pie with RECYCLE[1] color
  //                  UIColor.init(cgColor: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)).setFill()
                    let piePath = UIBezierPath()
                    piePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20, startAngle: 0, endAngle: CGFloat.pi * CGFloat(reuse) / CGFloat(count), clockwise: true)

                    piePath.addLine(to: CGPoint(x: 20, y: 20))
                    piePath.close()
                    piePath.fill()
                    
                    //fill inner circle with white color
                    UIColor.white.setFill()
                    UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 24, height: 24)).fill()
                    
                    // finally draw count text vertically and horizontally centered
                    let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)]
                    let text = "\(count)" as NSString
                    let size = text.size(withAttributes: attributes)
                    let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
                    
                    text.draw(in: rect, withAttributes: attributes)
                    
                    
                    
                    
                    
                    
                }
            }
        }
    }
    
}





extension CGFloat {
    func radians() -> CGFloat {
        let b = CGFloat(Double.pi) * (self/180)
        return b
    }
}

extension UIBezierPath {
    convenience init(circleSegmentCenter center:CGPoint, radius:CGFloat, startAngle:CGFloat, endAngle:CGFloat)
    {
        self.init()
        self.move(to: CGPoint(x: center.x, y: center.y))
        self.addArc(withCenter: center, radius:radius, startAngle:startAngle.radians(), endAngle: endAngle.radians(), clockwise:true)
        self.close()
    }
}



//func pieChart(pieces:[(UIBezierPath, UIColor)]) -> UIView {
//    var layers = [CAShapeLayer]()
//    for p in pieces {
//        let layer = CAShapeLayer()
//        layer.path = p.0.cgPath
//        layer.fillColor = p.1.cgColor
//        layer.strokeColor = UIColor.white.cgColor
//        layers.append(layer)
//    }
////    let view = UIView(frame: viewRect)
////    for l in layers {
////
////        view.layer.addSublayer(l)
////
////
////    }
//    return view
//}

