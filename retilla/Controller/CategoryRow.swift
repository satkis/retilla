//
//  PostCell.swift
//  retilla
//
//  Created by satkis on 1/23/18.
//  Copyright © 2018 satkis. All rights reserved.
//
import UIKit
import Firebase

class CategoryRow: UITableViewCell {

    @IBOutlet weak var collectionViewww: UICollectionView!

    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        print("setCollectionViewDataSourceDelegate")
        collectionViewww.delegate = dataSourceDelegate
        collectionViewww.dataSource = dataSourceDelegate
        collectionViewww.tag = row
        collectionViewww.reloadData()
    }
    
    override func draw(_ rect: CGRect) {
    }


    
    
    

    

}

