//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by John Ryan on 9/1/17.
//  Copyright © 2017 John Ryan. All rights reserved.
//

import UIKit
import Firebase
import LocalAuthentication
import NotificationCenter


//ToDo: Implement no network connection logic

class LoginController: UIViewController, UITextFieldDelegate, LoginInputAccessoryViewDelegate {
    
    var keychainPassword: String? = KeychainWrapper.standard.string(forKey: "passwordSaved")
    var keychainUser: String? = KeychainWrapper.standard.string(forKey: "emailSaved")
    
    let userCallBiometricsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Face ID!", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleUserRequestBiometrics), for: .touchUpInside)
        return button
    }()
    
    @objc func handleUserRequestBiometrics() {
        handleBiometricCheck { (success) in
            if success != true {
                self.handleBiometicsUnavailable()
            }
        }
    }
    
    func handleBiometicsUnavailable() {
        let alert = UIAlertController(title: "Face ID Not Available" , message: "Please use your password to login.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func didPressLogin(emailText: String, passwordText: String) {
        let emailTextString = emailText
        let passwordTextString = passwordText
        Auth.auth().signIn(withEmail: emailTextString, password: passwordTextString) { (user, err) in
            if err != nil {
                if let errorCode = AuthErrorCode(rawValue: err!._code) {
                    switch errorCode {
                    case .userNotFound: self.handleUserNotFound()
                    case .wrongPassword: self.handleIncorrectPassword(username: emailTextString, password: passwordTextString)
                    case .networkError: self.handleNetworkError()
                    default: print("Other error.")
                    }
                }
                print("The error code is", err ?? "")
                return
            }
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
//            if self.keychainPassword == nil {
//                KeychainWrapper.standard.set(email, forKey: "emailSaved")
//                KeychainWrapper.standard.set(password, forKey: "passwordSaved")
//            }
            NotificationCenter.default.post(name: Notification.Name("SuccessfulLogin"), object: nil)
            
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func passwordTextWillClear() {
        
    }
    
    func handleIncorrectPassword(username: String, password: String) {
        
        let alert = UIAlertController(title: "Incorrect password for \(username)" , message: "The password you entered is incorrect. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: { (_) in
//            self.passwordTextField.text?.removeAll()
        }))
        let controller = ForgotPassword()
        alert.addAction(UIAlertAction(title: "Forgot Password", style: .default, handler: { (_) in
            self.navigationController?.pushViewController(controller, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleUserNotFound() {
        let alert = UIAlertController(title: "Incorrect Username" , message: "The username you entered doesn't appear to belong to an account. Please check your username and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
        
        let controller = SignUpController()
        alert.addAction(UIAlertAction(title: "Sign Up!", style: .default, handler: { (_) in
            self.navigationController?.pushViewController(controller, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleNetworkError() {
        let alert = UIAlertController(title: "Connection Problem" , message: "You don't seem to be connected to any network.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: { (result) in
            let loginInputView = LoginInputAccessoryView()
            
            self.didPressLogin(emailText: loginInputView.emailTextField.text ?? "", passwordText: loginInputView.passwordTextField.text ?? "")
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func didPressForgotPassword() {
        let forgotPasswordController = ForgotPassword()
        navigationController?.pushViewController(forgotPasswordController, animated: true)
    }

    func didPressSignUp() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    lazy var frame = view.frame
    lazy var loginView = LoginInputAccessoryView(frame: frame)
    
    lazy var containerView: UIView = {
        loginView.delegate = self
        return loginView
    }()
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActive), name: Notification.Name("SuccessfulLogin"), object: nil)

//        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))

        view.isOpaque = true
        view.alpha = 1
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        view.addSubview(containerView)
        }
    
//    @objc func endEditing(gesture: UITapGestureRecognizer) {
//        handleEndEditing()
//    }
//
//    fileprivate func handleEndEditing() {
//        if emailTextField.isFirstResponder {
//            emailTextField.endEditing(true)
//        }
//        if passwordTextField.isFirstResponder {
//            passwordTextField.endEditing(true)
//        }
//        else {
//            return
//            //ToDo: Something else
//        }
//    }
    // ToDo: Biometrics HERE <<<<<-----------
    var userCancelled = false
    @objc func handleAppDidBecomeActive(notification: NSNotification) {
        handleBiometricCheck(completion: nil)
    }
    func handleBiometricCheck(completion: ((Bool) -> ())?) {
        var success = false
        let savedTogState = KeychainWrapper.standard.bool(forKey: "savedToggleState")
        if keychainPassword != nil && savedTogState == true && userCancelled == false {
            print("Call Touch ID")
            success = true
//            callBiometricAuth()
        }
        else {
            success = false
        }
        completion?(success)
    }
    
    
    //---///--/-//TODO: Reimplement Biometrics ------///---//////////-------------------
    
//    func callBiometricAuth() {
//        let myContext = LAContext()
//        let myLocalizedReasonString = "Please Sign On."
//        var authError: NSError?
//
//        if #available(iOS 8.0, *) {
//            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
//                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString, reply: { (success, err) in
//                    if success {
//                        DispatchQueue.main.async {
//                            self.passwordTextField.text = self.keychainPassword
//                            self.emailTextField.text = self.keychainUser
//                            self.handleLogin()
//                        }
//                    } else {
//                        print("There is an Auth error:", err ?? "")
//                        self.userCancelled = true
//                    }
//                })
//            } else {
//                print("Can't Do Auth This Way", authError ?? "")
//            }
//        }
//    }
//
//    fileprivate func handleBiometricError() {
//        let alert = UIAlertController(title: "Error" , message: "Please try again.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { (_) in
//            self.callBiometricAuth()
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }

}


















