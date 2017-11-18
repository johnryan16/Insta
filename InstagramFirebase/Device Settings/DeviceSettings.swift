//
//  DeviceSettings.swift
//  InstagramFirebase
//
//  Created by John Ryan on 11/17/17.
//  Copyright © 2017 John Ryan. All rights reserved.
//

import Foundation
import UIKit

class DeviceSettings: UIViewController {
    
    var currentToggleState: Bool?
    
    let touchSwitch: UISwitch = {
    let toggle = UISwitch()
    toggle.addTarget(self, action: #selector(switchDidChange), for: .valueChanged)
    return toggle
    }()
    
    @objc func switchDidChange() {
        if currentToggleState == false {
            currentToggleState = true
            print("Toggle State is now", currentToggleState ?? "")
            KeychainWrapper.standard.set(true, forKey: "savedToggleState")
            
        } else if currentToggleState == true {
            currentToggleState = false
            print("Toggle State is now", currentToggleState ?? "")
            KeychainWrapper.standard.set(false, forKey: "savedToggleState")
        }
    }
    
    func setDefaultSwitchState() {
        let savedToggleState = KeychainWrapper.standard.bool(forKey: "savedToggleState")
        print("Loaded toggleState of", savedToggleState ?? "")
        let defaultValue = false
        
        if savedToggleState == nil  {
            currentToggleState = defaultValue
            print("Default value loaded due to nil")
        }
        if savedToggleState == false {
            currentToggleState = false
            touchSwitch.isOn = false
        }
        if savedToggleState == true {
            currentToggleState = true
            touchSwitch.isOn = true
        }
    }
    
    let touchText: UILabel = {
       let field = UILabel()
        field.text = "TouchID Enabled?"
        field.textColor = .blue
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(touchText)
        touchText.anchor(top: view.safeAreaLayoutGuide.centerYAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 35, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(touchSwitch)
        
        setDefaultSwitchState()
        touchSwitch.anchor(top: view.safeAreaLayoutGuide.centerYAnchor, left: touchText.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
       
    }
}
