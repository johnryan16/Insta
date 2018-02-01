//
//  UserProfileEditor.swift
//  InstagramFirebase
//
//  Created by John Ryan on 1/21/18.
//  Copyright © 2018 John Ryan. All rights reserved.
//

import UIKit

class UserProfileEditor: UITableViewController, UINavigationControllerDelegate {
    
    let userInfoCellId = "UserInfoCell"
    
    override func viewDidLoad() {
//        tableView.backgroundColor = .red
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone))
        
        tableView.register(UserProfileInfoCell.self, forCellReuseIdentifier: userInfoCellId)
        tableView.separatorColor = .purple
        
        self.tableView.tableFooterView = UIView()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userInfoCellId, for: indexPath) as! UserProfileInfoCell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone() {
        print("Handle Done... which will save any changes... which will be fun implementing.")
    }
    
}
