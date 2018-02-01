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
        name.backgroundColor = .clear
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value2, reuseIdentifier: nil)
        
        backgroundColor = .magenta
        
        addSubview(nameText)
        nameText.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 75, height: 50)
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
