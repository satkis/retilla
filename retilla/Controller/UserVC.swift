//
//  UserVC.swift
//  retilla
//
//  Created by satkis on 4/30/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit
import Firebase

class UserVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var currentUser_DBRef: DatabaseReference!
//    var imageCachee = NSCache<AnyObject, AnyObject>()
    var postInUserVCC: postInUserVC!
    
    var postsInUserVC = [postInUserVC]()
    
    var user: User!
    var imgUrl: String!
    
    var emaii: String!
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postCounterLbl: UILabel!
    @IBOutlet weak var reactionsLbl: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
 
        setupNavigationBarItems()
        
        currentUser_DBRef = DataService.instance.URL_USER_CURRENT
        
        currentUser_DBRef.observeSingleEvent(of: .value) { (snapshot) in
            
           let snap = snapshot.value as? Dictionary<String, AnyObject>
            print("snap::: \(String(describing: snap))")
            
            let key = snapshot.key
            let user = User(userKey: key, dictionary: snap!)
            
            self.emaii = user.email
            
            let emaill = user.email
            print("emaill ll \(emaill)")
            
            let email = snap?["email"] as? String
            let firstName = snap?["first_name"] as? String
            //let lastName = snap?["last_name"] as? String
//            let fullName = snap?["name"] as? String
            
            if user.first_name != nil {
                self.userNameLbl.text  = user.first_name
            } else if user.email.contains("@") {
                let emailCutOff = user.email.components(separatedBy: "@").first
                self.userNameLbl.text = emailCutOff
            } else if user.email.contains("Anonymous") {
                self.userNameLbl.text = "Anonymous"
            } else {
                self.userNameLbl.text = "no user ID"
            }
            
            
            
        }
 
        currentUser_DBRef.child("posts").observeSingleEvent(of: .value) { (snapshot) in
            if let postsnapshots = snapshot.children.allObjects as? [DataSnapshot] {
                self.postCounterLbl.text = String(postsnapshots.count)
            }
        }
        
        
        
        
        currentUser_DBRef.child("posts").observe(.value) { (snapshottt) in
            
            print("snapshottt: \(snapshottt.value)")
            
            self.postsInUserVC = []
            
            if let snapshots = snapshottt.children.allObjects as? [DataSnapshot] {
                for snapp in snapshots {
                    print("snaPP: \(snapp)")
                    if let postDictt = snapp.value as? Dictionary<String, AnyObject> {
                        let key = snapp.key
                        print("keY: \(key)")
                        let postt = postInUserVC(postKey: key, dictionary: postDictt)
                        
                        self.postsInUserVC.append(postt)
                    }
                }
            }
            
            self.collection.reloadData()
        }
        
        
        
        


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        currentUser_DBRef.child("reactions").observeSingleEvent(of: .value) { (snapshot) in
            if let reactsnapshots = snapshot.children.allObjects as? [DataSnapshot] {
                self.reactionsLbl.text = String(reactsnapshots.count)
            }
            self.reloadInputViews()
        }
        
//        currentUser_DBRef.child("posts").observeSingleEvent(of: .value) { (snapshott) in
//            if snapshott.exists() {
//                for childd in snapshott.children {
//                    let snapp = childd as! DataSnapshot
////                    let dict = snapp.value as! [String: Any]
////                    let dict = Dictionary<String, AnyObject>
//
//                    let dictt: Dictionary<String, Any> = [
//                        "urlToImg": self.imgUrl]
////                    let urlToImg = dict["urlToImg"] as! String
//                    //self.image
//
//                    print("snappy: \(snapp)")
//                    print("dictty: \(dictt)")
////                    print("urlToImgg: \(urlToImg)")
//
//                    if let postDictt =
//
//                }
//
//            }
//        }
        
        

        
        
        
    }
    
   private func setupNavigationBarItems() {
        print("setupNavig FUnc is called")

        let userIcon = UIImageView(image: #imageLiteral(resourceName: "userIcon"))
        userIcon.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        userIcon.contentMode = .scaleAspectFit
        navigationItem.titleView = userIcon
    
    let settingsButton = UIButton(type: .infoLight)
    settingsButton.setImage(#imageLiteral(resourceName: "settingsIcon").withRenderingMode(.alwaysOriginal), for: .normal)
    settingsButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
    settingsButton.contentMode = .scaleToFill
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingsButton)
    settingsButton.addTarget(self, action: #selector(settingsClicked(_ :)), for: .touchUpInside)
    self.view.addSubview(settingsButton)
    }
    
    @objc func settingsClicked(_ : UIButton) {
        self.performSegue(withIdentifier: SEGUE_TOSETTINGSVC, sender: self)
    }
    
//    @IBAction func settingsButton(_ sender: UIButton) {
//        self.performSegue(withIdentifier: SEGUE_TOSETTINGSVC, sender: self)
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == SEGUE_TOSETTINGSVC {
//            if let destination = segue.destination as? SettingsVC {
//                perform
//            }
//        }
//    }
    


    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let postt = postsInUserVC[indexPath.item]
        print("posTT: \(String(describing: postt.imageUrl))")
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCellinUserVC", for: indexPath) as? PostCellInUserVC {
            cell.request?.cancel()

            var image: UIImage?
            
            if let urll = postt.imageUrl {
                image = FeedVCC.imageCache.object(forKey: urll as AnyObject) as? UIImage
            }
            
            
            cell.configCell(post: postt, image: image)
            
            return cell
            
        } else {
            return PostCellInUserVC()
        }
        
        }
 
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsInUserVC.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
  
    
    
}
