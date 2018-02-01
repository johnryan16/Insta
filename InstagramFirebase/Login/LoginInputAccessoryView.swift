//
//  LoginInputAccessoryView.swift
//  InstagramFirebase
//
//  Created by John Ryan on 1/10/18.
//  Copyright © 2018 John Ryan. All rights reserved.
//

import UIKit
import Firebase

protocol LoginInputAccessoryViewDelegate {
    func didPressLogin(emailText: String, passwordText: String)
    func handleBiometricCheck(result: @escaping ((Bool) -> ()))
    func callBiometricAuth()
    func didPressSignUp()
    func didPressForgotPassword()
}

class LoginInputAccessoryView: UIView, UITextFieldDelegate, UINavigationControllerDelegate {
    
    var delegate: LoginInputAccessoryViewDelegate?
    
    func clearPasswordTextField() {
        passwordTextField.text = nil
    }
    
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
    
    let userCallBiometricsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Face ID!", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleUserRequestBiometrics), for: .touchUpInside)
        return button
    }()
    
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
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc func handleUserRequestBiometrics() {
        delegate?.handleBiometricCheck(result: { (success) in
            if success {
                self.delegate?.callBiometricAuth()
            }
            else {
                return
            }
        })
    }
    
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
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        delegate?.didPressLogin(emailText: email, passwordText: password)
    }
    
    @objc func handleForgotPassword() {
        delegate?.didPressForgotPassword()
    }
    
    @objc func handleShowSignUp() {
        delegate?.didPressSignUp()
    }

    @objc func stopEditing() {
        handleEndEditing()
    }
    
    fileprivate func handleEndEditing() {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stopEditing)))
        
        isOpaque = true
        alpha = 1
        backgroundColor = .white
        
        addSubview(logoContainerView)
                logoContainerView.anchor(top: topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        
        setupInputFields()
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(handleLoginViewWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
    }
    
//    @objc func handleLoginViewWillEnterForeground() {
//        delegate?.handleBiometricCheck(result: { (successful) in
//            if successful {
//                self.delegate?.callBiometricAuth()
//            }
//            else {
//                print("Conditions not met. Do not call Biometrics.")
//            }
//        })
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleMakeInputsFirstResponders()
        return true
    }
    
    fileprivate func handleMakeInputsFirstResponders() {
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
        
        addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
        
        addSubview(forgotPasswordButton)
        forgotPasswordButton.anchor(top: stackView.bottomAnchor, left: stackView.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(resetPasswordButton)
        resetPasswordButton.anchor(top: nil, left: forgotPasswordButton.rightAnchor, bottom: forgotPasswordButton.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: -5, paddingRight: 0, width: 0, height: 0)
        
        addSubview(userCallBiometricsButton)
        userCallBiometricsButton.anchor(top: forgotPasswordButton.bottomAnchor, left: stackView.centerXAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: -25, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, left: nil, bottom: safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        dontHaveAccountButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
