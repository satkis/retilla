//
//  FeedVCC.swift
//  retilla
//
//  Created by satkis on 1/27/18.
//  Copyright © 2018 satkis. All rights reserved.
//
import UIKit
import Firebase

class FeedVCC: UITableViewController {
    
    var categories = ["Recycle"] //, "Reuse", "Reduce", "Pollution"]
   
    @IBOutlet weak var tableViewwww: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CategoryRow.collectionView.dataSource = self
        
//        tableView.delegate = self
//        tableView.dataSource = self
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
            
            //return tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryRow
            
            let categoryRoww = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryRow
            return categoryRoww
        }

}



extension FeedVCC: CellCollectionViewDelegatee {
    func didSelect() {
        performSegue(withIdentifier: SEGUE_POSTDETAILVC, sender: nil)
        dismiss(animated: true, completion: nil)
    }
    


}









