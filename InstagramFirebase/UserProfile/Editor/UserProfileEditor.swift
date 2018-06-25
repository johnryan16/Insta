//
//  UserProfileEditor.swift
//  InstagramFirebase
//
//  Created by John Ryan on 6/18/18.
//  Copyright © 2018 John Ryan. All rights reserved.
//

import UIKit

class UserProfileEditor: UIViewController {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        
        label.font = UIFont.systemFont(ofSize: 17)
        label.backgroundColor = .blue
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.systemFont(ofSize: 17)
        label.backgroundColor = .blue
        return label
    }()
    
    let websiteLabel: UILabel = {
        let label = UILabel()
        label.text = "Website"
        label.font = UIFont.systemFont(ofSize: 17)
        label.backgroundColor = .blue
        return label
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "Bio"
        label.font = UIFont.systemFont(ofSize: 17)
        label.backgroundColor = .blue
        return label
    }()
    
    
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.autocapitalizationType = UITextAutocapitalizationType.words
//        tf.backgroundColor = .red
//        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
//        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 17)
        return tf
    }()
    
    let lineSeparatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return separator
    }()
    
    
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.autocapitalizationType = UITextAutocapitalizationType.none
//        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
//        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    
    let websiteTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Website"
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        //        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        //        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    
    let bioTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Bio"
        tf.autocapitalizationType = UITextAutocapitalizationType.sentences
        //        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        //        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Edit Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone))
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        
        let labelsStackView = UIStackView(arrangedSubviews: [nameLabel, usernameLabel, websiteLabel, bioLabel])
        labelsStackView.distribution = .fillEqually
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 10
        
        view.addSubview(labelsStackView)
        
        labelsStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 180)
        
        view.addSubview(nameTextField)
        nameTextField.anchor(top: labelsStackView.topAnchor, left: labelsStackView.rightAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 0, height: 35)
        
        view.addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: nameTextField.bottomAnchor, left: nameTextField.leftAnchor, bottom: nil, right: nameTextField.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone() {
        print("Handle Done here.")
    }

}
