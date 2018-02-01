//
//  AppDelegate.swift
//  InstagramFirebase
//
//  Created by John Ryan on 8/31/17.
//  Copyright © 2017 John Ryan. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "hasRunBefore") == false {
            KeychainWrapper.standard.removeObject(forKey: "passwordSaved")
            KeychainWrapper.standard.removeObject(forKey: "savedToggleState")
            KeychainWrapper.standard.removeObject(forKey: "emailSaved")
            handleLogout()
            
            userDefaults.set(true, forKey: "hasRunBefore")
//            userDefaults.synchronize()
        }
        window = UIWindow()
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
        
        let checkUidValue = Auth.auth().currentUser
        if checkUidValue != nil {
            attemptRegisterForNotification()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleSuccessfulLogin), name: Notification.Name("SuccessfulLogin"), object: nil)
        
        return true
    }
    
    @objc func handleSuccessfulLogin() {
        print("Received Success Notifier. Do some Login Stuff Here... Maybe......")
        attemptRegisterForNotification()
    }
    
    func handleLogout() {
        do{
            try Auth.auth().signOut()
        } catch let signOutError {
            print("Failed to sign out for reason:", signOutError)
        }
    }
    
//    func checkUserAgainstAuth(completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
//        let currentUser = Auth.auth().currentUser
//        if currentUser == nil {
//            completion(false, nil)
//        }
//        currentUser?.getIDTokenForcingRefresh(true) { (idToken, error) in
//            if let error = error {
//                completion(false, error as NSError?)
//                print(error.localizedDescription)
//            } else {
//                completion(true, nil)
//            }
//        }
//    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for notifications:", deviceToken)
        handleFcmTokenStatus()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Registered with FCM with token:", fcmToken)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if let followerId = userInfo["followerId"] as? String {
            print(followerId)
            
            //Push user profile controller for folloerID HERE
            let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
            userProfileController.userId = followerId
            
            //Access main UI from Appdelegate
            if let mainTabBarController = window?.rootViewController as? MainTabBarController {
                
                mainTabBarController.selectedIndex = 4
                mainTabBarController.presentedViewController?.dismiss(animated: true, completion: nil)
                
                if let homeNavigationController = mainTabBarController.viewControllers?.first as? UINavigationController {
                    homeNavigationController.pushViewController(userProfileController, animated: true)
                }
            }
        }
    }
    
    private func attemptRegisterForNotification() {
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        guard let myApplication = UIApplication.shared as UIApplication? else { return }
        
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, err) in
            if let err = err {
                print("Failed to request auth", err)
                return
            }
            if granted {
                print("Auth granted.")
            } else {
                print("Auth denied.")
            }
        }
        myApplication.registerForRemoteNotifications()
    }
    
    func handleFcmTokenStatus() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let checkLocation = Database.database().reference().child("users").child(uid).child("fcmToken")
        checkLocation.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? String
            if value == nil {
                guard let fcmToken = Messaging.messaging().fcmToken else { return }
                let values = ["fcmToken": fcmToken]
                Database.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if let err = err {
                        print("Failed to save user info to F-DB:", err)
                        return
                    }
                    print("Successfully Saved user to DB")
                })
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        //TouchID window, Multitask after Doubletap
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //After selecting another app in multitasking window OR going home
        let biometricsStatus = KeychainWrapper.standard.bool(forKey: "savedToggleState")
        if biometricsStatus == false {
            KeychainWrapper.standard.removeObject(forKey: "passwordSaved")
            let testBioStatus = KeychainWrapper.standard.bool(forKey: "passwordSaved")
            print("The saved password before termination is:", testBioStatus ?? "")
        }
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        //After selecting from multitask window or from home screen
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // Happens on ANY Load
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        //Manual Close
    }
}

