//
//  AppDelegate.swift
//  prova
//
//  Created by Marco Di Lullo on 27/11/2018.
//  Copyright © 2018 Marco Di Lullo. All rights reserved.
//

import UIKit
import PushNotifications
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate{

    var window: UIWindow?
    let pushNotifications = PushNotifications.shared
    let center = UNUserNotificationCenter.current()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.pushNotifications.start(instanceId: "d34ad54c-7107-4c4f-ba63-d3d87e034acd")
        self.pushNotifications.registerForRemoteNotifications()
        try? self.pushNotifications.subscribe(interest: "hello2")
        
        center.delegate = self
        
        let alertCategory = UNNotificationCategory(identifier: "ALERT_CATEGORY",
                                                   actions: [],
                                                   intentIdentifiers: [],
                                                   options: .customDismissAction)
        
        let mapCategory = UNNotificationCategory(identifier: "MAP_CATEGORY",
                                                 actions: [],
                                                 intentIdentifiers: [],
                                                 options: .customDismissAction)
        
        // Register the category.
        
        center.setNotificationCategories([alertCategory, mapCategory])
        
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
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.pushNotifications.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        self.pushNotifications.handleNotification(userInfo: userInfo)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.notification.request.content.categoryIdentifier {
        case "MAP_CATEGORY":
            let sb = UIStoryboard(name: "Main", bundle: nil)
            /*let mapViewController = sb.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            window?.rootViewController = mapViewController;*/
        default:
            break
        }
    }

}




