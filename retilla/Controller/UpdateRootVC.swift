//
//  UpdateRootVC.swift
//  retilla
//
//  Created by satkis on 7/27/18.
//  Copyright © 2018 satkis. All rights reserved.
//



//https://medium.com/@paul.allies/ios-swift4-login-logout-branching-4cdbc1f51e2c

import Foundation
import UIKit

class Switcher {
    static func updateRootVC() {
        let status = UserDefaults.standard.bool(forKey: "status")
        var rootVC: UIViewController?
        
        print("status rootVC", status)
        
        
        if (status == true) {
            
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

           rootVC = storyboard.instantiateViewController(withIdentifier: "feedVC") as! FeedVCC
//                rootVC?.navigationController?.present(rootVC!, animated: true, completion: nil)

            let navig = UINavigationController(rootViewController: rootVC!)
            
//            UINavigationController.setNavigationBarHidden(rootVC)
            navig.setNavigationBarHidden(false, animated: true)
            
//            rootVC?.navigationController?.pushViewController(rootVC!, animated: true)
//
//            UINavigationController.pushViewController(true)
            
            //rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "aaa") as! MainMapVC
            
            
            
            
        } else {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! ViewController
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
    }
    
    
}
