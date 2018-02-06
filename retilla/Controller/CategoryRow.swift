//
//  PostCell.swift
//  retilla
//
//  Created by satkis on 1/23/18.
//  Copyright © 2018 satkis. All rights reserved.
//
import UIKit
import Firebase

protocol CellCollectionViewDelegatee {
    func didSelect(data: String)
}

class CategoryRow: UITableViewCell {

    @IBOutlet weak private var collectionViewww: UICollectionView!
    
    static var imageCache = NSCache<AnyObject, AnyObject>()
    var delegate: CellCollectionViewDelegatee?
    var posts = [Post]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionViewww.delegate = self
        collectionViewww.dataSource = self
        
        
        //even this is in viewdidload, below will be called only when data changes
        DataService.instance.URL_POSTS.observe(.value) { (snapshot) in
            print(snapshot.value as Any)
            self.posts = []
            
            //this gives us data individual (every post separate array/dict?)
            //snapshot is like "posts" or "users" in Firebase, and snap is "likes", "hashtag" etc
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    print("SNAP::: \(snap)")
                    
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        //key is user/post ID
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDictionary)
                        self.posts.append(post)
                    }
                }
            }
            
            self.collectionViewww.reloadData()
        }
    }
    
    override func draw(_ rect: CGRect) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 221
    }
    
}


extension CategoryRow: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("collecitonViewTag: \(collectionView.tag)")
        return posts.count
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let post = posts[indexPath.row]

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? PostCell {
            
            cell.request?.cancel()
            
            var image: UIImage?
            
            if let url = post.imageUrl {
                //set image in cache as image(if it exists). if not, then image will be downloaded
                image = CategoryRow.imageCache.object(forKey: url as AnyObject) as? UIImage
            }
            
            cell.configureCell(post: post, image: image)
            return cell
            
        } else {
            return PostCell()
        }
    }
    
    //identify which postcell was selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let data = posts[indexPath.row].hashtag
        //let testText = "testingData"

        delegate?.didSelect(data: data!)

        print("CategoryRow Prints?: \(String(describing: data!))")
        print("degelateee value::: \(String(describing: delegate?.didSelect(data: data!)))")
 }

    func didSelect(data: String) {
        print("CategoryRow didSelect func::: \(data)")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    

}

