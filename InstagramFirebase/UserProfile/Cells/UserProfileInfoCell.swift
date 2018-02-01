//
//  UserInfoCell.swift
//  InstagramFirebase
//
//  Created by John Ryan on 1/27/18.
//  Copyright © 2018 John Ryan. All rights reserved.
//

import UIKit

class UserProfileInfoCell: UITableViewCell {
    
    var user: User?
    
    let nameText: UITextView = {
        let name = UITextView()
        name.text = "Name"
        name.font = UIFont.systemFont(ofSize: 18)
        return name
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value2, reuseIdentifier: nil)
        
//        backgroundColor = .red
        
        addSubview(nameText)
        nameText.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 20, paddingRight: 0, width: 75, height: 75)
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
