//
//  Post.swift
//  InstagramFirebase
//
//  Created by John Ryan on 9/4/17.
//  Copyright © 2017 John Ryan. All rights reserved.
//

import Foundation

struct Post {
    
    let user: User
    let imageUrl: String
    let caption: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
    }
    
}

