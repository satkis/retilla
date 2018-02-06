//
//  FeedVCC.swift
//  retilla
//
//  Created by satkis on 1/27/18.
//  Copyright © 2018 satkis. All rights reserved.
//
import UIKit
import Firebase

class FeedVCC: UITableViewController, CellCollectionViewDelegatee {
   
    var categories = ["Section 1"] //, "Section 2", "Section 3", "Section 4"]
    var posts = [Post]()
    
    var delegate: CellCollectionViewDelegatee?
    
    override func viewDidLoad() {
        super.viewDidLoad()

                tableView.delegate = self
                tableView.dataSource = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //        return categories.count
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categoryRoww = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryRow
        
        categoryRoww.delegate = self
        return categoryRoww
    }
    
}

extension FeedVCC: UICollectionViewDelegate {
 
    func didSelect(data: String) {
        
        print("FeedVCC didSelect func::: \(data)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_POSTDETAILVC {
            if let detailVC = segue.destination as? PostDetailVCC {
            detailVC.delegate = self
   
            }
        }
    }
}

 