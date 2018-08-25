//
//  RulesVC.swift
//  retilla
//
//  Created by satkis on 8/25/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit

class RulesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func loginBttnPressed(_ sender: Any) {
        let initialVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = initialVC
    }
    
}
