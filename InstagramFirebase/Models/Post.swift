//
//  Post.swift
//  InstagramFirebase
//
//  Created by John Ryan on 9/4/17.
//  Copyright © 2017 John Ryan. All rights reserved.
//

import Foundation

struct Post {
    let imageUrl: String
    
    init(dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
    
}

