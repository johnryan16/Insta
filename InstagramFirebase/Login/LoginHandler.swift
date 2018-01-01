//
//  LoginHandler.swift
//  InstagramFirebase
//
//  Created by John Ryan on 12/27/17.
//  Copyright © 2017 John Ryan. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications


protocol loginHandler {
    func handleLogin()
}

class LoginHandler: UIViewController {
    
    open func handleFirebaseEmailLogin(email: String, password: String, completion: @escaping (Bool) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if err != nil {
                if let errorCode = AuthErrorCode(rawValue: err!._code) {
                    switch errorCode {
                    case .userNotFound: self.handleUserNotFound()
                    case .wrongPassword: self.handleIncorrectPassword(username: email)
                    case .networkError: self.handleNetworkError()
                    default: print("Other error.")
                    }
                    print("The error code is", err ?? "")
                }
                return
            }
            completion(true)
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            // ToDo: handle keychainPassword == nil HERE........Function?
            
             NotificationCenter.default.post(name: Notification.Name("SuccessfulLogin"), object: nil)
            
            //ToDo: handle inputFields 1st Responders HERE..........Function?
            mainTabBarController.setupViewControllers()
        }
    }
    
    fileprivate func handleNetworkError() {
        
        let alert = UIAlertController(title: "Connection Problem" , message: "You don't seem to be connected to any network.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: { (result) in
        //do login again here
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func handleUserNotFound() {
        let alert = UIAlertController(title: "Incorrect Username" , message: "The username you entered doesn't appear to belong to an account. Please check your username and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
        
        let controller = SignUpController()
        alert.addAction(UIAlertAction(title: "Sign Up!", style: .default, handler: { (_) in
            self.navigationController?.pushViewController(controller, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func handleIncorrectPassword(username: String) {
        let alert = UIAlertController(title: "Incorrect password for \(username)" , message: "The password you entered is incorrect. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: { (_) in
        }))
        let controller = ForgotPassword()
        alert.addAction(UIAlertAction(title: "Forgot Password", style: .default, handler: { (_) in
            self.navigationController?.pushViewController(controller, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func handleIncorrectPassword(email: String?) {
        let alert = UIAlertController(title: "Incorrect password for \(email ?? "")" , message: "The password you entered is incorrect. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: { (_) in
        }))
        let controller = ForgotPassword()
        alert.addAction(UIAlertAction(title: "Forgot Password", style: .default, handler: { (_) in
            self.navigationController?.pushViewController(controller, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
        handlerBlock(true)
    }
    
    let handlerBlock: (Bool) -> Void = {
        doneWork in
        if doneWork {
            print("We've finished working, bruh.")
        }
    }
    

    
    
}
    
    
    
    
    
    
    
    


