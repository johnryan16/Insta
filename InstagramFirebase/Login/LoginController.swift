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

class LoginController: UIViewController, UITextFieldDelegate {

    let logoContainerView: UIView = {
        let view = UIView()
        
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        logoImageView.contentMode = .scaleAspectFill

        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        return view
    }()

    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = UIKeyboardType.emailAddress
        tf.textContentType = UITextContentType.emailAddress
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.autocorrectionType = UITextAutocorrectionType.no
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.clearButtonMode = .whileEditing
        tf.enablesReturnKeyAutomatically = true
        tf.returnKeyType = .next
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()

    var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.clearButtonMode = .whileEditing
        tf.enablesReturnKeyAutomatically = true
        tf.returnKeyType = .go
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        return result
    }

    @objc func handleTextInputChange() {
        let validEmail = isValidEmail(email: emailTextField.text ?? "")
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 5 && validEmail == true
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }

    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)

        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if err != nil {
                if let errorCode = AuthErrorCode(rawValue: err!._code) {
                    switch errorCode {
                    case .userNotFound: self.handleUserNotFound()
                    case .wrongPassword: self.handleIncorrectPassword()
                    default: print("Other error.")
                    }
                }
                return
            }
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            if self.keychainPassword == nil {
                KeychainWrapper.standard.set(email, forKey: "emailSaved")
                KeychainWrapper.standard.set(password, forKey: "passwordSaved")
            }
            
            NotificationCenter.default.post(name: Notification.Name("SuccessfulLogin"), object: nil)
            
            if self.emailTextField.isFirstResponder {
                self.emailTextField.resignFirstResponder()
            } else if self.passwordTextField.isFirstResponder && self.loginButton.isEnabled {
                self.passwordTextField.resignFirstResponder()
            }
            
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
            }
//            else {
//                print("Email NOT Verified")
//                let alert = UIAlertController(title: "Email Not Verified", message: "Please verify your email address.", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
//                    do{
//                        try Auth.auth().signOut()
//                        KeychainWrapper.standard.removeObject(forKey: "passwordSaved")
//                    } catch let signOutErr {
//                        print("Failed to sign out for some reason:", signOutErr)
//                    }
//                    self.passwordTextField.text?.removeAll()
//                }))
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
    }
    fileprivate func handleIncorrectPassword() {
        guard let username = emailTextField.text else { return }
        let alert = UIAlertController(title: "Incorrect password for \(username)" , message: "The password you entered is incorrect. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: { (_) in
            self.passwordTextField.text?.removeAll()
        }))
        let controller = ForgotPassword()
        alert.addAction(UIAlertAction(title: "Forgot Password", style: .default, handler: { (_) in
            self.navigationController?.pushViewController(controller, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
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
    let forgotPasswordButton: UILabel = {
        let questionText = UILabel()
        questionText.text = "Forgot your password?"
        questionText.font = UIFont.systemFont(ofSize: 14)
        questionText.textColor = .darkGray
        return questionText
    }()
    let resetPasswordButton: UIButton = {
       let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Reset Password", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        return button
    }()
    @objc func handleForgotPassword() {
        let forgotPasswordController = ForgotPassword()
        navigationController?.pushViewController(forgotPasswordController, animated: true)
    }
    
    let dontHaveAccountButton: UIButton = {
       let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])

        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()

    @objc func handleShowSignUp() {
        let signUpController = SignUpController()

        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    let myContext = LAContext()
    let myLocalizedReasonString = "Please Sign On."
    var authError: NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)

        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white

        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        setupInputFields()
        
        handleBiometricCheck()
        
        }
    
    @objc func endEditing(gesture: UITapGestureRecognizer) {
        if emailTextField.isFirstResponder {
        emailTextField.endEditing(true)
        }
        if passwordTextField.isFirstResponder {
            passwordTextField.endEditing(true)
        }
        else {
            return
            //ToDo: Something else
        }
    }
    
    @objc func handleAppDidBecomeActive(notification: NSNotification) {
        handleBiometricCheck()
    }
    
    func handleBiometricCheck() {
        let presentTouchID = KeychainWrapper.standard.bool(forKey: "savedToggleState")
        if keychainPassword != nil && presentTouchID == true {
            callTouchId()
            print("Called Touch ID")
        }
    }
    
    var keychainPassword: String? = KeychainWrapper.standard.string(forKey: "passwordSaved")
    
    var keychainUser: String? = KeychainWrapper.standard.string(forKey: "emailSaved")
    
    func callTouchId() {
        if #available(iOS 8.0, *) {
            if self.myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &self.authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString, reply: { (success, err) in
                    if success {
                        DispatchQueue.main.async {
                            self.passwordTextField.text = self.keychainPassword
                            self.emailTextField.text = self.keychainUser
                            self.handleLogin()
                        }
                    } else {
                        print("There is an Auth error:", err ?? "")
                    }
                })
            } else {
                print("Can't Do Auth This Way", authError ?? "")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleInputsFirstResponders()
        return true
    }
    
    fileprivate func handleInputsFirstResponders() {
        if emailTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField.isFirstResponder && loginButton.isEnabled {
            passwordTextField.resignFirstResponder()
            handleLogin()
        }
    }

    
    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
        
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.anchor(top: stackView.bottomAnchor, left: stackView.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(resetPasswordButton)
        resetPasswordButton.anchor(top: nil, left: forgotPasswordButton.rightAnchor, bottom: forgotPasswordButton.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: -5, paddingRight: 0, width: 0, height: 0)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    
}


















