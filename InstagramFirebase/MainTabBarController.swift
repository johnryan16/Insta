//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by John Ryan on 8/31/17.
//  Copyright © 2017 John Ryan. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let redVC = UIViewController()
        redVC.view.backgroundColor = .red
        
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let navController = UINavigationController(rootViewController: userProfileController)
        
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = .black
        
        viewControllers = [navController, UIViewController()]
    
    }
}
