//
//  PostCellInUserVC.swift
//  retilla
//
//  Created by satkis on 7/22/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCellInUserVC: UICollectionViewCell {
    
    var postInUserVC: postInUserVC!
    var imageUrl: String?
    var request: Request?
    

    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var sectionImg: UIImageView!
    
    
    
//    layer.cornerRadius = 5
//    layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//    layer.shadowRadius = 5

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//
//
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
    
    
    func configCell(post: postInUserVC, image: UIImage?) {
        self.postInUserVC = post
        
        if postInUserVC.imageUrl != nil {
            imageUrl = postInUserVC.imageUrl
            self.postImg.image = nil
            
            if image != nil {
                self.postImg.image = image
            } else {
                request = Alamofire.request(post.imageUrl!, method: .get).validate(contentType: ["image/*"]).responseData(completionHandler: { (response) in
                    
                    if let data = response.result.value {
                        
                        let image = UIImage(data: data)!
                        
                        if self.imageUrl == post.imageUrl {
                            self.postImg.image = image
                        }
                        
                        //add to cache if image was downloaded
                        FeedVCC.imageCache.setObject(image, forKey: self.postInUserVC.imageUrl as AnyObject)
                    } else {
                        print("ALAMOFIRE ERROR::: \(String(describing: response.result.error))")
                    }
                })
            }
        } else {
            self.postImg.isHidden = true
        }
        
        if let sectionNr = postInUserVC.sectionNo {
            //let sectionn = "\(sectionNr)"
            let img0 = UIImage(named: "circle0")
            let img1 = UIImage(named: "circle1")
            let img2 = UIImage(named: "circle2")
            let img3 = UIImage(named: "circle3")
            
            if sectionNr == 0 {
                sectionImg.image = img0
            } else if sectionNr == 1 {
                 sectionImg.image = img1
            } else if sectionNr == 2 {
                 sectionImg.image = img2
            } else if sectionNr == 3 {
                 sectionImg.image = img3
            } else {
                 sectionImg.image = img0
            }
        }
        
        
        
        
        
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

}
