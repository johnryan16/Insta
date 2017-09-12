//
//  FirebaseUtils.swift
//  InstagramFirebase
//
//  Created by John Ryan on 9/10/17.
//  Copyright © 2017 John Ryan. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        print("Fetching user with uid:", uid)
        
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            
            completion(user)
            
            //            self.fetchPostsWithUser(user: user)
        }) { (error) in
            print("Failed to fetch user for posts.")
        }
    }
}