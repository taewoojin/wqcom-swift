//
//  AppDelegate.swift
//  wqcom
//
//  Created by 진태우 on 2017. 8. 29..
//  Copyright © 2017년 jjlee. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseMessaging
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var badgeCount:Int = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FIRApp.configure()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
        view.backgroundColor = UIColor(red:0.75, green:0.70, blue:0.55, alpha:1.0)
        self.window?.rootViewController?.view.addSubview(view)
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            FIRMessaging.messaging().remoteMessageDelegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        tokenRefreshNotification()
        
        // init badge count
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        return true
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let state: UIApplicationState = UIApplication.shared.applicationState
        let center = UNUserNotificationCenter.current()
        
        badgeCount = badgeCount + 1
        
        print("badge count::::::\(UIApplication.shared.applicationIconBadgeNumber)")
        
        if state == .active{
            if let notification = userInfo["aps"] as? [AnyHashable: Any],
                let alert = notification["alert"] as? String {
                
                let localNotification = UILocalNotification()
                localNotification.alertBody = alert
                localNotification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.shared.scheduleLocalNotification(localNotification)
            }
        }else if state == .inactive{
            
            if let notification = userInfo["aps"] as? [AnyHashable: Any],let alert = notification["alert"] as? String {
                print(alert)
                let localNotification = UILocalNotification()
                localNotification.alertBody = alert
                localNotification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.shared.scheduleLocalNotification(localNotification)
                
            }
        }else if state == .background{
            let notification = userInfo["aps"] as? [AnyHashable: Any]
            let alert = (notification?["alert"] as? [AnyHashable: Any])?["body"] as? String
//            let sound = notification?[0]["sound"] as? String
            
            if (notification != nil) && (alert != nil) {
                
                let content = UNMutableNotificationContent()
                content.badge = badgeCount as NSNumber
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                let request = UNNotificationRequest(identifier: "alarmRequest", content: content, trigger: trigger)
                
                center.add(request, withCompletionHandler: { (errorObject) in
                    if let error = errorObject{
                        print("Error \(error.localizedDescription) in notification alarmRequest")
                    }
                    else {
                        print("===success====")
                    }
                })
                
            }
        }
        
        
        
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
        
        
        
        // Print full message.
        print("userInfo::::::\(userInfo)")
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        connectToFcm()
//        UIApplication.shared.applicationIconBadgeNumber = 0
//        badgeCount = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "wqcom")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = ((deviceToken as NSData).description.trimmingCharacters(in: CharacterSet(charactersIn: "<>")) as NSString).replacingOccurrences(of: " ", with: "")
        
        print("Notification 등록 성공: \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Notification 등록 실패: \(error.localizedDescription)")
    }
    
    
    func tokenRefreshNotification() {
        let fcmDeviceToken = FIRInstanceID.instanceID().token()
        print("token::::\(String(describing: fcmDeviceToken))")
        // TODO: Send token to server
    }
    
    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(String(describing: error))")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
}

extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print("%@", remoteMessage.appData)
    }
}

