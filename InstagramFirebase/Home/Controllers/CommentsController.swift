//
//  CommentsController.swift
//  InstagramFirebase
//
//  Created by John Ryan on 9/19/17.
//  Copyright © 2017 John Ryan. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CommentInputAccessoryViewDelegate {
    
    var post: Post?
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        collectionView?.backgroundColor = .white
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
        fetchComments()
 
    }
    
    var comments = [Comment]()
    
    fileprivate func fetchComments() {
        guard let postId = self.post?.id else { return }
        let ref = Database.database().reference().child("comments").child(postId)
        ref.observe(.childAdded, with: { (snapshot) in
            
            print(snapshot.value ?? "")
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            guard let uid = dictionary["uid"] as? String else { return }
            
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
                
                let comment = Comment(user: user, dictionary: dictionary)
                
                self.comments.append(comment)
                self.collectionView?.reloadData()
                
            })
        }) { (err) in
            print("Failed to observe comments")
        }
    }
    
    var user: User?
    fileprivate func fetchUserFields() {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 50)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        cell.comment = self.comments[indexPath.item]
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    lazy var containerView: CommentInputAccessoryView = {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView
        
    }()
    
    func didSubmit(for comment: String) {
        print("trying to insert comment into firebase")
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let postID = post?.id ?? ""
            let values = ["text": comment, "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String : Any]
            
            let userPostRef = Database.database().reference().child("comments").child(postID)
            let ref = userPostRef.childByAutoId()
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to enter comment", err)
                    return
                }
                self.containerView.clearCommentTextField()
                
                let recipientUid = self.post?.user.uid ?? ""
                let userRef = Database.database().reference().child("users").child(recipientUid).child("fcmToken")
                userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let value = snapshot.value else { return }  //this is Token here <<<--------
                    let tokenValue = ["recipientFcmToken": value]
                    ref.updateChildValues(tokenValue) { (err, ref) in
                        if let err = err {
                            print("Failed to enter comment", err)
                            return
                        }
                    }
                })
            }
    }
    
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}


















