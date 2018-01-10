//
//  DeviceSettings.swift
//  InstagramFirebase
//
//  Created by John Ryan on 11/17/17.
//  Copyright © 2017 John Ryan. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import LocalAuthentication

class DeviceSettings: UIViewController {
    
    var currentToggleState: Bool?
    
    let touchSwitch: UISwitch = {
    let toggle = UISwitch()
    toggle.addTarget(self, action: #selector(switchDidChange), for: .valueChanged)
    return toggle
    }()
    
    @objc func switchDidChange() {
        let canAuthenticate = LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &self.authError)
        if canAuthenticate {
            if currentToggleState == false {
                //            handleBiometricsEnable()
                currentToggleState = true
                print("Toggle State is now", currentToggleState ?? "")
                KeychainWrapper.standard.set(true, forKey: "savedToggleState")
            }
            else {
                currentToggleState = false
                print("Toggle State is now", currentToggleState ?? "")
                KeychainWrapper.standard.set(false, forKey: "savedToggleState")
            }
        }
        else {
            print("Biometrics not enabled on system.")
        }
    }
    
    func handleBiometricsEnable() {
        let alertController = UIAlertController(title: "Enter Password", message: "Enter your password to enable TouchID", preferredStyle: .alert)
        alertController.addTextField { (password) in
            password.isSecureTextEntry = true
            password.placeholder = "Password"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (result) in
            self.touchSwitch.isOn = false
            print("Canceled at first request popup. Set toggle to off/false.")
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (result) in
            guard let passwordText = alertController.textFields?.first?.text else { return }
            guard let currentUserEmail = Auth.auth().currentUser?.email else { return }
            Auth.auth().currentUser?.reauthenticate(with: EmailAuthProvider.credential(withEmail: currentUserEmail, password: passwordText), completion: { (err) in
                if let err = err {
                    print("There's a reauth error", err)
                    self.touchSwitch.isOn = false
                    self.currentToggleState = false
//                    self.handleReauthErrorWindow()
                    print("Toggle State is now", self.currentToggleState ?? "")
                    KeychainWrapper.standard.set(false, forKey: "savedToggleState")
                    return
                }
                self.currentToggleState = true
                print("Toggle State is now", self.currentToggleState ?? "")
                KeychainWrapper.standard.set(true, forKey: "savedToggleState")
            })
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    let myContext = LAContext()
    var authError: NSError?
    let myLocalizedReason = "Enabling Bios"
    
    
    func checkBiometrics() -> Bool {
        var authenticated = false
        if #available(iOS 8.0, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &self.authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReason, reply: { (success, error) in
                    if success {
                        authenticated = true
                    }
                    if success != true {
                        authenticated = false
                        print("There was an error:", error ?? "")
                    }
                })
            }
        }
        return authenticated
    }
    
    
//    func handleReauthErrorWindow() {
//        let errorAlert = UIAlertController(title: "Incorrect Login Credentials", message: "Your email and/or password are incorrect.", preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (result) in
//            print("Canceling at Error Popup.")
//        }
//        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default, handler: { (result) in
//            self.handleRequestPasswordToEnableAlert()
//        })
//        errorAlert.addAction(tryAgainAction)
//        errorAlert.addAction(cancelAction)
//
//        self.present(errorAlert, animated: true, completion: nil)
//    }
    
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
    
    let touchText: UILabel = {
       let field = UILabel()
        field.text = "TouchID Enabled?"
        field.textColor = .blue
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleBack))
        view.addSubview(touchText)
        touchText.anchor(top: view.safeAreaLayoutGuide.centerYAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 35, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        loadSwitchState()
        view.addSubview(touchSwitch)
        touchSwitch.anchor(top: view.safeAreaLayoutGuide.centerYAnchor, left: touchText.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc func handleBack() {
        handleKeychainUpdates()
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func handleKeychainUpdates() {
        if currentToggleState != true {
            KeychainWrapper.standard.removeObject(forKey: "passwordSaved")
            print("Removed Password from Keychain")
        }
        if currentToggleState == true {
            KeychainWrapper.standard.set(true, forKey: "savedToggleState")
        }
    }
}














