//
//  AppDelegate.swift
//  Tinder
//
//  Created by Marco Linhares on 8/22/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        Parse.enableLocalDatastore ()
        
        Parse.setApplicationId ("RF0LSDX019sc6ElJ7O6hJwncuiUYTXaUMdFcDJmq", clientKey: "nzNQ0rCpfkOIBRE9SvmnT1zJnRnhcHrw0jXYmjYZ")
        
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions (launchOptions)

        // código do Parse para receber e enviar notificações
        
        // descreve o tipo de notificações que queremos usar (no caso, são alertas)
        let pushSettings = UIUserNotificationSettings (forTypes: UIUserNotificationType.Alert, categories: nil)
        
        application.registerUserNotificationSettings(pushSettings)
        
        application.registerForRemoteNotifications()

        return true
    }

    // quando o usuário aceita receber notificações
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        println ("success requested notifications")
        
        // Store the deviceToken in the current Installation and save it to Parse

        let installation = PFInstallation.currentInstallation()
        
        installation.setDeviceTokenFromData(deviceToken)
        
        installation.saveInBackground()
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {

        println ("fail to register for notifications")
        
        println (error.localizedDescription)
    }
    
    
    // para fazer funcionar o login via Facebook
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject?) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        FBSDKAppEvents.activateApp()
    }
 
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

