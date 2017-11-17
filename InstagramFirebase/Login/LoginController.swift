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


//ToDo: Implement no network connection logic

class LoginController: UIViewController {

    let logoContainerView: UIView = {
        let view = UIView()

        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        logoImageView.contentMode = .scaleAspectFill


        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        return view
    }()

    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = UIKeyboardType.emailAddress
        tf.textContentType = UITextContentType.emailAddress
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
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
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()

    @ objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 &&  passwordTextField.text?.characters.count ?? 0 > 5

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
    
    var keychainPassword: String? = KeychainWrapper.standard.string(forKey: "passwordSaved")
    var keychainUser: String? = KeychainWrapper.standard.string(forKey: "emailSaved")

    

    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if let err = err {
                print("Failed to sign in with email:", err)
                return
            }
            print("Successfully logged back in with user:", user?.uid ?? "")

            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            
            if self.keychainPassword == nil {
                KeychainWrapper.standard.set(email, forKey: "emailSaved")
                KeychainWrapper.standard.set(password, forKey: "passwordSaved")
            }
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        }
    }

    let dontHaveAccountButton: UIButton = {
       let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])

        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))

        button.setAttributedTitle(attributedTitle, for: .normal)

        button.setTitle("Don't have an account?  Sign Up.", for: .normal)
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
    let myLocalizedReasonString = "Just do it."
    var authError: NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("String password is", keychainPassword ?? "")

        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)

        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white

        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)

        setupInputFields()

        }
    
    fileprivate func callTouchId() {
        if #available(iOS 8.0, *) {
            if self.myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &self.authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString, reply: { (success, err) in
                    if success {
                        DispatchQueue.main.async {
                            self.passwordTextField.text = self.keychainPassword
                            self.emailTextField.text = self.keychainUser
                            self.handleLogin()
                            print(self.passwordTextField)
                        }
                    } else {
                        print("Auth error", err ?? "")
                    }
                })
            } else {
                print("Can't Do Auth This Way", authError ?? "")
            }
        }
    }

        fileprivate func setupInputFields() {
            let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])

            stackView.axis = .vertical
            stackView.spacing = 10
            stackView.distribution = .fillEqually

            view.addSubview(stackView)
            stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
            callTouchId()

    }
}


















