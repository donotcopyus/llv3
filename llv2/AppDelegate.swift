//
//  AppDelegate.swift
//  LunaLauren
//
//  Created by Luna Cao on 2018/7/5.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        let storyboard = UIStoryboard(name:"Main",bundle:nil)
        
        let authListener = Auth.auth().addStateDidChangeListener{
            auth, user in
            
            if user != nil{
                UserService.observeUserProfile(user!.uid){
                    userProfile in
                    UserService.currentUserProfile = userProfile
                }
                
                let controller = storyboard.instantiateViewController(withIdentifier: "revealController") as! revealController
                
                self.window?.rootViewController = controller
                    self.window?.makeKeyAndVisible()
            }
            else{
                UserService.currentUserProfile = nil
                
                let controller = storyboard.instantiateViewController(withIdentifier: "loginController") as! loginController
                
                self.window?.rootViewController = controller
                self.window?.makeKeyAndVisible()
            }
            
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
//    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        self.splashScreen()
//        return true
//    }
//
    
    
//    private func splashScreen() {
//        let launchScreenVC = UIStoryboard.init(name: "LaunchSreen", bundle: nil)
//        let rootVC = launchScreenVC.instantiateInitialViewController(withIdentifier: "splashController")
//        self.window?.rootViewController = rootVC
//        self.window?.makeKeyAndVisible()
//        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(dismissSplashController), userInfo: nil, repeats: false)
//    }
//
//    @objc func dismissSplashController() {
//        let mainVC = UIStoryboard.init(name: "Main", bundle: nil)
//        let rootVC = mainVC.instantiateViewController(withIdentifier: "loginController")
//        self.window?.rootViewController = rootVC
//        self.window?.makeKeyAndVisible()
//    }


}

