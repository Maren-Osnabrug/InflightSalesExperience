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

import PopupDialog

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
    
    // The callback to handle data message MessagingRemoteMessageces running iOS 10 or above.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
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

        if let aps = userInfo["aps"] as? [String: AnyObject] {
            if let alert = aps["alert"] as? [String: AnyObject] {
                let title = alert["title"] as? String ?? "New Order"
                let body = alert["body"] as? String ?? "A new order has come in"
                showNewOrderPopup(title: title, body: body)
            }
        }
    }
    
    func showNewOrderPopup(title: String, body: String) {
        let popup = PopupDialog(title: title, message: body, buttonAlignment: .horizontal,
                                transitionStyle: .bounceUp, gestureDismissal: true, hideStatusBar: true)
        let buttonOne = DefaultButton(title: "Ok") {}
        popup.addButton(buttonOne)
        window?.rootViewController?.present(popup, animated: true, completion: nil)
    }
}

