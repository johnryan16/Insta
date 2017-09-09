//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by John Ryan on 9/8/17.
//  Copyright © 2017 John Ryan. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        setupNavigationItems()
        
        fetchPosts()
        
    }
    
    func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_black"))
    }
    
    var posts = [Post]()
    
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                
                guard let dictionary = value as? [String: Any] else { return }
                
                let imageUrl = dictionary["imageUrl"] as? String
                print("Image URL: \(imageUrl ?? "")")
                
                let post = Post(dictionary: dictionary)
                
                self.posts.append(post)
            })
            
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Falied to fetch posts:", err)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        
        cell.post = posts[indexPath.item]
        
        
        
        return cell
    }
}
