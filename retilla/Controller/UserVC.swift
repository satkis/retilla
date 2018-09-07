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

    var postInUserVCC: postInUserVC!
    
    var postsInUserVC = [postInUserVC]()
    
    var user: User!
    var imgUrl: String!
    
    var emaii: String!
    var selectedRow = 0
    

    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postCounterLbl: UILabel!
    //@IBOutlet weak var reactionsLbl: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var reuseLbl: UILabel!
    @IBOutlet weak var recycleLbl: UILabel!
    @IBOutlet weak var reduceLbl: UILabel!
    @IBOutlet weak var pollutionLbl: UILabel!
    
    @IBOutlet weak var emptyStateText: UILabel!
    @IBOutlet weak var emptyStateButton: UIButtonX!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self

        
        
        let width = (view.frame.size.width - 6) / 3
        let layout = collection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
 
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
            
            if user.first_name != nil {
                self.userNameLbl.text  = user.first_name
            } else if user.email.contains("@") {
                let emailCutOff = user.email.components(separatedBy: "@").first
                self.userNameLbl.text = emailCutOff
            } else if user.email.contains("Guest") {
                self.userNameLbl.text = "Guest"
            } else {
                self.userNameLbl.text = "no user ID"
            }

        }
 
        currentUser_DBRef.child("posts").observeSingleEvent(of: .value) { (snapshot) in
            if let postsnapshots = snapshot.children.allObjects as? [DataSnapshot] {
                self.postCounterLbl.text = String(postsnapshots.count)
                
                if String(postsnapshots.count) == "\(0)" {
                    self.emptyStateButton.isHidden = false
                    self.emptyStateText.isHidden = false
                } else {
                    self.emptyStateButton.isHidden = true
                    self.emptyStateText.isHidden = true
                }
                
            }
        }
        
        currentUser_DBRef.child("posts").queryOrdered(byChild: "section").queryEqual(toValue: 0).observeSingleEvent(of: .value) { (snapyy) in
            if let category0 = snapyy.children.allObjects as? [DataSnapshot] {
                print("category0 \(category0.count)")
                self.reuseLbl.text = String(category0.count)
            }
        }
        
        currentUser_DBRef.child("posts").queryOrdered(byChild: "section").queryEqual(toValue: 1).observeSingleEvent(of: .value) { (snapyy) in
            if let category1 = snapyy.children.allObjects as? [DataSnapshot] {
                print("category1 \(category1.count)")
                self.recycleLbl.text = String(category1.count)
            }
        }
        
        currentUser_DBRef.child("posts").queryOrdered(byChild: "section").queryEqual(toValue: 2).observeSingleEvent(of: .value) { (snapyy) in
            if let category2 = snapyy.children.allObjects as? [DataSnapshot] {
                print("category2 \(category2.count)")
                self.reduceLbl.text = String(category2.count)
            }
        }
        
        currentUser_DBRef.child("posts").queryOrdered(byChild: "section").queryEqual(toValue: 3).observeSingleEvent(of: .value) { (snapyy) in
            if let category3 = snapyy.children.allObjects as? [DataSnapshot] {
                print("category3 \(category3.count)")
                self.pollutionLbl.text = String(category3.count)
            }
        }
        


    }


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        
        currentUser_DBRef.child("posts").observe(.value) { (snapshottt) in

            self.postsInUserVC = []
            
            if let snapshots = snapshottt.children.allObjects as? [DataSnapshot] {
                for snapp in snapshots {
                    print("snaPP: \(snapp)")
                    if let postDictt = snapp.value as? Dictionary<String, AnyObject> {
                        let key = snapp.key
                        print("keY: \(key)")
                        let postt = postInUserVC(postKey: key, dictionary: postDictt)

                        self.postsInUserVC.insert(postt, at: 0)
                    }
                }
            }
            
            self.collection.reloadData()
        }
  
        
    }
    
   private func setupNavigationBarItems() {
        print("setupNavig FUnc is called")

    let rr = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(settingsClicked(_:)))
    navigationItem.rightBarButtonItem = rr
    
    let container = UIView(frame: CGRect(x: 0, y: 0, width: 122, height: 23))
    let logo = UIImage(named: "logoo_darker")
   
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 122, height: 23))
    imageView.image = logo
    imageView.layer.masksToBounds = true
    imageView.clipsToBounds = true
    
    container.addSubview(imageView)
    navigationItem.titleView = container

    }
    
    @objc func settingsClicked(_ : UIButton) {
        self.performSegue(withIdentifier: SEGUE_TOSETTINGSVC, sender: self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let postt = postsInUserVC[indexPath.item]
        print("posTT: \(String(describing: postt.imageUrl))")
        
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCellinUserVC", for: indexPath) as? PostCellInUserVC {
            

            cell.request?.cancel()
            
            cell.layer.cornerRadius = 3
            cell.layer.masksToBounds = true
            
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
        selectedRow = indexPath.item
        debugPrint("collectionView.tag_USERVC", collectionView.tag)
        debugPrint("indexPath.item_USERVC", indexPath.item)
        let post = postsInUserVC[indexPath.item]
        print("selectedPostusername_USERVC::", post.imageUrl as Any)

        self.performSegue(withIdentifier: SEGUE_POSTDETAILVC, sender: post)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == SEGUE_POSTDETAILVC) {
            let postDetailVC = segue.destination as! PostDetailVCC
            postDetailVC.userName = postsInUserVC[selectedRow].username
            postDetailVC.cityy = postsInUserVC[selectedRow].location_city
            postDetailVC.countryy = postsInUserVC[selectedRow].location_country
            postDetailVC.postStoryy = postsInUserVC[selectedRow].postStory
            postDetailVC.sectionNumberr = postsInUserVC[selectedRow].sectionNo
            postDetailVC.hashtagg = postsInUserVC[selectedRow].hashtag
            postDetailVC.postTimeStampp = postsInUserVC[selectedRow].timestamp
            postDetailVC.imagee = postsInUserVC[selectedRow].imageUrl
            
            postDetailVC.latt = postsInUserVC[selectedRow].lat
            postDetailVC.longg = postsInUserVC[selectedRow].long
            
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("countcount::", postsInUserVC.count)
        return postsInUserVC.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func switchToCreatePostVC() {
        Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(switchToCreatePostVCSection), userInfo: nil, repeats: false)
    }
    
    @objc func switchToCreatePostVCSection(){
        tabBarController!.selectedIndex = 1
    }
    
    @IBAction func emptyStateBttnTapped(_ sender: Any) {
        switchToCreatePostVC()
    }
    
    
}
