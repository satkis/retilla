//
//  PostDetailVC.swift
//  retilla
//
//  Created by satkis on 1/27/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit

class PostDetailVCC: UIViewController {

    var post: Post!
    
    @IBOutlet weak var descLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if post != nil {
            descLabel.text = post.postStory
        } else {
            descLabel.text = "Failed to load"
        }
        
    }

    
    
    
}

