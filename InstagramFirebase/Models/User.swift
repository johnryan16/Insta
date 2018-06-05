//
//  User.swift
//  InstagramFirebase
//
//  Created by John Ryan on 9/10/17.
//  Copyright © 2017 John Ryan. All rights reserved.
//

import Foundation

struct User {
    
    let profileImageUrl: String
    let uid: String
    let name: String
    let username: String
    let website: String
    let bio: String
    
    
    init(uid: String, dictionary: [String: Any]) {
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = uid
        self.name = dictionary["name"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.website = dictionary["website"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
    }
}
