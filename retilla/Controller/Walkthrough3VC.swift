//
//  Walkthrough3VC.swift
//  retilla
//
//  Created by satkis on 8/11/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit

class Walkthrough3VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func letsGoTapped(_ sender: Any) {
        performSegue(withIdentifier: SEGUE_TO_VIEWCONTROLLERVC, sender: self)
    }

}
