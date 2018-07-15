//
//  HeaderView.swift
//  retilla
//
//  Created by satkis on 6/25/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit

class HeaderView: UITableViewCell {
    @IBOutlet var headerImageView: UIImageView!
    
    @IBOutlet var headerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
