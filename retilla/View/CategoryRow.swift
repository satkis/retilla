//
//  PostCell.swift
//  retilla
//
//  Created by satkis on 1/23/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit

class CategoryRow: UITableViewCell, UICollectionViewDataSource {

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func draw(_ rect: CGRect) {
        //google. not sure why to round corenrs in draw rect override and not awakefromnib

        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! UICollectionViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 221
    }
    
    

}
