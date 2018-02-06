//
//  PostDetailVC.swift
//  retilla
//
//  Created by satkis on 1/27/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit

class PostDetailVCC: UIViewController, CellCollectionViewDelegatee, UICollectionViewDelegate {

    //var post: Post!
    var delegate: CellCollectionViewDelegatee?
    
    @IBOutlet weak var descLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func didSelect(data: String) {
        print("detailVCC didSelect::: \(data)")
        descLabel.text = data
    }
}

