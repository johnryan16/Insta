//
//  ProfileEditorCell.swift
//  InstagramFirebase
//
//  Created by John Ryan on 6/21/18.
//  Copyright © 2018 John Ryan. All rights reserved.
//

import UIKit

class ProfileEditorTextFieldCell: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        addSubview(lineSeparatorView)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
