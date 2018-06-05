//
//  UserInfoCell.swift
//  InstagramFirebase
//
//  Created by John Ryan on 1/27/18.
//  Copyright © 2018 John Ryan. All rights reserved.
//

import UIKit

class UserProfileInfoCell: UITableViewCell {
    
    var user: User? {
        didSet {
            
        }
    }
    
    var labelText: UILabel = {
        let label = UILabel()
        label.text = "Filler"
        label.font = UIFont.systemFont(ofSize: 18)
        label.backgroundColor = .white //remove this later
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()
    
    let textFieldEntry: UITextField = {
        let textEntry = UITextField()
        textEntry.placeholder = "Placeholder"
        textEntry.font = UIFont.systemFont(ofSize: 20)
        textEntry.tintColor = .orange
        return textEntry
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value2, reuseIdentifier: nil)
        
        backgroundColor = .magenta
        
        
        addSubview(labelText)
        labelText.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 15, paddingRight: 0, width: 0, height: 0)
        
        addSubview(textFieldEntry)
        textFieldEntry.anchor(top: nil, left: labelText.rightAnchor, bottom: labelText.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 50, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let separatorView = UIView()
        //        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        separatorView.backgroundColor = .blue
        addSubview(separatorView)
        separatorView.anchor(top: nil, left: textFieldEntry.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
