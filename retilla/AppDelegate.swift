//
//  AppDelegate.swift
//  retilla
//
//  Created by satkis on 1/22/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit
import FacebookCore
import Firebase
import GoogleSignIn
import AppAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    //var fbAccessToken: AccessToken?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
//        GIDSignIn.sharedInstance().clientID = "41622738363-efr12s81k1q1ebfqe4v4mk8ek2annucd.apps.googleusercontent.com"
         GIDSignIn.sharedInstance().delegate = self
        
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Switcher.updateRootVC()

        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let err = error {
            print("failed to log in into Google", err)
        } else {
            print("singed in with GOOGLE successfully", user)
            guard let googleIDToken = user.authentication.accessToken else { return }
            guard let googleAccessToken = user.authentication.accessToken else { return }
            let credentials = GoogleAuthProvider.credential(withIDToken: googleIDToken, accessToken: googleAccessToken)
            
            Auth.auth().signIn(with: credentials) { (user, error) in
                if let err = error {
                    print("failed to create Firebase user with Google acct", err)
                    return
                } else {
                    guard let uid = user?.uid else { return }
                    print("successfully logged into FIrebase with Google", user?.uid)
//                    self.currentUser = Auth.auth().currentUser
//                    UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: KEY_UID)
//                    self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                    print("logged in and sent to FeedVC after Google login")
                }
            }
        }
    }
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = SDKApplicationDelegate.shared.application(app, open: url, options: options)
        return handled
    }
        

    
    

    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return  GIDSignIn.sharedInstance().handle(url,sourceApplication: sourceApplication, annotation: annotation)
        
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

