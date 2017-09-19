//
//  Comment.swift
//  InstagramFirebase
//
//  Created by John Ryan on 9/19/17.
//  Copyright © 2017 John Ryan. All rights reserved.
//

import Foundation

struct Comment {
    let text: String
    let uid: String
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
