//
//  ResetPasswordVC.swift
//  retilla
//
//  Created by satkis on 5/1/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {


    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    var effect: UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        animateIn()
        
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        
    }
    
    
    func animateIn() {
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.popUpView.alpha = 1
            self.popUpView.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func closePopUP(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var resetPwdButton: UIButton!
    



}
