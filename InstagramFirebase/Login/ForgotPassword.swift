//
//  ForgotPassword.swift
//  InstagramFirebase
//
//  Created by John Ryan on 11/19/17.
//  Copyright © 2017 John Ryan. All rights reserved.
//
import Foundation
import UIKit
import Firebase

class ForgotPassword: UIViewController {
    
    let titleText: UILabel = {
        let label = UILabel()
        label.text = "Reset your Password."
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = NSTextAlignment.center
        label.textColor = .white
        return label
    }()
    let returnToLoginText: UIButton = {
        let button = UIButton()
        button.setTitle("Back To Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleReturnToLogin), for: .touchUpInside)
        return button
    }()
    
    @objc func handleReturnToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        let attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1.0, alpha: 1.0)])
        tf.attributedPlaceholder = attributedPlaceholder
        tf.keyboardType = UIKeyboardType.emailAddress
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.autocorrectionType = .no
        tf.backgroundColor = UIColor(white: 1.0, alpha: 0.30)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = .white
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    @objc func handleTextInputChange() {
        let validEmail = isValidEmail(email: emailTextField.text ?? "")
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && validEmail == true
        
        if isFormValid {
            sendEmailButton.isEnabled = true
            sendEmailButton.setTitleColor(.white, for: .normal)
        } else {
            sendEmailButton.isEnabled = false
            sendEmailButton.setTitleColor(UIColor(white: 1.0, alpha: 0.55), for: .normal)
        }
    }
    let sendEmailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Email Link to Reset", for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 5
        let whiteBorderColor = UIColor.white
        button.layer.borderColor = whiteBorderColor.cgColor
        button.layer.borderWidth = 1.0
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor(white: 1.0, alpha: 0.55), for: .normal)
        button.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    @objc func handleReset() {
        guard let email = emailTextField.text else { return }

        Auth.auth().sendPasswordReset(withEmail: email) { (err) in
            if let err = err {
                print("There is an error:", err)
            }
            print("Sent reset email to", email)
            let alert = UIAlertController(title: "Email Sent" , message: "We sent an email to \(self.emailTextField.text ?? "") with a link to get back into your account, if the address is valid.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 73, green: 174, blue: 229)
        
        setupFieldsAndText()
        }
    
    fileprivate func setupFieldsAndText() {
        view.addSubview(returnToLoginText)
        returnToLoginText.anchor(top: nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(titleText)
        titleText.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 60, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        setupInputFields()
    }
    
    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, sendEmailButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.anchor(top: view.centerYAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: -70, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 100)
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        return result
    }
}
    
    

