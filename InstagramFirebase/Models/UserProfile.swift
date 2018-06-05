//
//  UserProfile.swift
//  InstagramFirebase
//
//  Created by John Ryan on 2/13/18.
//  Copyright © 2018 John Ryan. All rights reserved.
//

import Foundation

struct UserProfile {
    
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
