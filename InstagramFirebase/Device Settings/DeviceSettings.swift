//
//  DeviceSettings.swift
//  InstagramFirebase
//
//  Created by John Ryan on 11/17/17.
//  Copyright © 2017 John Ryan. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication
import UserNotifications
import Firebase

class DeviceSettings: UIViewController {
    
    var currentToggleState: Bool?
    let myContext = LAContext()
    var authError: NSError?
    let myLocalizedReason = "Enabling Bios"
    
    let touchSwitch: UISwitch = {
    let toggle = UISwitch()
    toggle.addTarget(self, action: #selector(switchDidChange), for: UIControl.Event.valueChanged)
    return toggle
    }()

    let touchText: UILabel = {
        let field = UILabel()
        field.text = "TouchID Enabled?"
        field.textColor = .blue
        return field
    }()
    
    lazy var canAuthenticateOnViewAppear = LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &self.authError)
    
    lazy var canAuthenticate = LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &self.authError)
    
    @objc func switchDidChange() {
        if canAuthenticate {
            if currentToggleState == false {
                setSwitchStatus(toState: true)
            }
            else {
                setSwitchStatus(toState: false)
            }
        }
        else {
            print("Cannot auth")
            setSwitchStatus(toState: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadSwitchState()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleBack))
        view.addSubview(touchText)
        touchText.anchor(top: view.safeAreaLayoutGuide.centerYAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 35, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(touchSwitch)
        touchSwitch.anchor(top: view.safeAreaLayoutGuide.centerYAnchor, left: touchText.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if canAuthenticateOnViewAppear {
            canAuthenticate = true
        }
        else {
            canAuthenticate = false
            setSwitchStatus(toState: false)
        }
    }
    
    func loadSwitchState() {
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
    
    func setSwitchStatus(toState: Bool) {
        if toState == false {
            self.touchSwitch.isOn = false
            self.currentToggleState = false
            handleKeychainUpdates()
        }
        if toState == true {
            self.touchSwitch.isOn = true
            self.currentToggleState = true
            analyticsTest()
            handleKeychainUpdates()
        }
    }
    
    func analyticsTest() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        Analytics.logEvent("using_Biometrics", parameters: ["user" : currentUser])
        print("Update analytics")
    }
    
    @objc func handleBack() {
        handleKeychainUpdates()
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func handleKeychainUpdates() {
        if currentToggleState != true {
            KeychainWrapper.standard.set(false, forKey: "savedToggleState")
            print("Toggle state still false. Delete from keychain on resignActive if still false.")
        }
        if currentToggleState == true {
            KeychainWrapper.standard.set(true, forKey: "savedToggleState")
        }
    }
}
    
//    func checkBiometrics() -> Bool {
//        var authenticated = false
//        if #available(iOS 8.0, *) {
//            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &self.authError) {
//                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReason, reply: { (success, error) in
//                    if success {
//                        authenticated = true
//                    }
//                    if success != true {
//                        authenticated = false
//                        print("There was an error:", error ?? "")
//                    }
//                })
//            }
//        }
//        return authenticated
//    }

//    func handleBiometricsEnable() {
//        let alertController = UIAlertController(title: "Enter Password", message: "Enter your password to enable TouchID", preferredStyle: .alert)
//        alertController.addTextField { (password) in
//            password.isSecureTextEntry = true
//            password.placeholder = "Password"
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (result) in
//            self.touchSwitch.isOn = false
//            print("Canceled at first request popup. Set toggle to off/false.")
//        }
//        let okAction = UIAlertAction(title: "OK", style: .default) { (result) in
//            guard let passwordText = alertController.textFields?.first?.text else { return }
//            guard let currentUserEmail = Auth.auth().currentUser?.email else { return }
//            Auth.auth().currentUser?.reauthenticate(with: EmailAuthProvider.credential(withEmail: currentUserEmail, password: passwordText), completion: { (err) in
//                if let err = err {
//                    print("There's a reauth error", err)
//                    self.touchSwitch.isOn = false
//                    self.currentToggleState = false
//                    print("Toggle State is now", self.currentToggleState ?? "")
//                    KeychainWrapper.standard.set(false, forKey: "savedToggleState")
//                    return
//                }
//                self.currentToggleState = true
//                print("Toggle State is now", self.currentToggleState ?? "")
//                KeychainWrapper.standard.set(true, forKey: "savedToggleState")
//            })
//        }
//        alertController.addAction(cancelAction)
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
//    }













