//
//  PostCellIInCollection.swift
//  retilla
//
//  Created by satkis on 1/26/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {

    var userPost: Post!
    
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var postDateLbl: UILabel!
    
    @IBOutlet weak var postImg: UIImageView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var commentsCuntLbl: UILabel!
    
    @IBOutlet weak var readStoryLbl: UILabel!
    
    @IBOutlet weak var reactionLbl: UIImageView!
    
    
    func configureCell(userPost: Post) {
        self.userPost = userPost
        
        if let username = userPost.username, userPost.username != "" {
            self.userNameLbl.text = username
        }
    }
    
    


    
    
    
    
    
    
}
