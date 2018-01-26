//
//  PostCellIInCollection.swift
//  retilla
//
//  Created by satkis on 1/26/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {

    var post: Post!
    
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var postDateLbl: UILabel!
    
    @IBOutlet weak var postImg: UIImageView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var commentsCountLbl: UILabel!
    
    @IBOutlet weak var readStoryLbl: UILabel!
    
    @IBOutlet weak var reactionCountLbl: UILabel!
    
    
//    func configureCell(post: Post) {
//        self.post = post
//
//        if let post = post.likes, post.likes != "" {
//        self.reactionCountLbl.text = "\(post.likes)"
//        }
    
        func configureCell(post: Post) {
            self.post = post
            
            if let reactionCount = post.likes, post.likes != nil {
            self.reactionCountLbl.text = String(reactionCount)
            } else {
               self.reactionCountLbl.text = String()
            }
    }
    
    


    
    
    
    
    
    
}
