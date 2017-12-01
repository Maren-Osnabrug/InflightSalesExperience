//
//  AppDelegate.swift
//  ISX-CabinCrew
//
//  Created by Maren Osnabrug on 29-11-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import UIKit
import Firebase

import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().barStyle = UIBarStyle.blackOpaque
        UINavigationBar.appearance().tintColor = .white
        UIApplication.shared.registerForRemoteNotifications()
        FirebaseConfiguration.shared.setLoggerLevel(FirebaseLoggerLevel.min)
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
            Messaging.messaging().shouldEstablishDirectChannel = true
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        
        if let gai = GAI.sharedInstance(),
            let gaConfigValues = Bundle.main.infoDictionary?["GoogleAnalytics"] as? [String: String],
            let trackingId = gaConfigValues["TRACKING_ID"] {
            gai.dispatchInterval = 1
            gai.trackUncaughtExceptions = false
            gai.tracker(withTrackingId: trackingId)
        } else {
            assertionFailure("Google Analytics not configured correctly")
        }
        Database.database().isPersistenceEnabled = true
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
    
    // The callback to handle data message MessagingRemoteMessageces running iOS 10 or above.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
        let d : [String : Any] = remoteMessage.appData["notification"] as! [String : Any]
        let body : String = d["body"] as! String
        let controller = UIAlertController(title: "In App Notification", message: body, preferredStyle: .alert)
        window?.rootViewController?.present(controller, animated: true, completion: nil)
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("did refresh", fcmToken)
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Let FCM know about the message for analytics etc.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        print(userInfo)
        print(userInfo["aps"])
        print(userInfo["aps"]["alert"])
        print(userInfo["aps"]["alert"])
        if let aps = userInfo["aps"] as? [String:AnyObject] {
            if let alert = aps["alert"] as? [String:AnyObject] {
                if let message = alert["body"] as? [String:AnyObject] {
                    let controller = UIAlertController(title: message["title"] as? String, message: message["body"] as? String, preferredStyle: .alert)
                    window?.rootViewController?.present(controller, animated: true, completion: nil)
                }
            }
        }
        // handle your message

    }
}

