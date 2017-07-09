//
//  AppDelegate.swift
//  PrestaNotificationsF
//
//  Created by Ignas Paulionis on 04/01/2017.
//  Copyright © 2017 Ignas Paulionis. All rights reserved.
//
import UIKit
import UserNotifications
import Alamofire
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        //let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: //"notificationController") as UIViewController
        
        
       // self.window = UIWindow(frame: UIScreen.main.bounds)
        //self.window?.rootViewController = initialViewControlleripad
        //self.window?.makeKeyAndVisible()
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // [END register_for_notifications]
        FIRApp.configure()
        
        // [START add_token_refresh_observer]
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        // [END add_token_refresh_observer]
        return true
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        //print(userInfo)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        //print(userInfo)
        NotificationCenter.default.post(name: NSNotification.Name("RefreshTable"), object: nil)
        
        let preferences = UserDefaults.standard
        
        let message = userInfo["message"]
        let type = userInfo["type"]
        let message_date = userInfo["message_date"]
        let order_reference = userInfo["order_reference"]
        let buyer_name = userInfo["buyer_name"]
        let cost = userInfo["cost"]
        let url = userInfo["url"]
        let payment_method = userInfo["payment_method"]
        let order_status = userInfo["order_status"]
        
        // Create a dictionary and add it to the array.
        let dictionary = ["message": message,
                          "type":type,
                          "message_date": message_date,
                          "order_reference":order_reference,
                          "buyer_name":buyer_name,
                          "cost" : cost,
                          "url" : url,
                          "payment_method":payment_method,
                          "order_status" : order_status]
        
        var finished_dictionary = [[String: String]]()
        print("patenkaaaaaaaaaa")
        print(dictionary)
        
        
        if let dictionaries = preferences.object(forKey: "notificationn") as? [[String:String]]{
            
            
            for i in 0 ..< dictionaries.count  {
                finished_dictionary.append(dictionaries[i])
            }
            
            finished_dictionary.append(dictionary as! [String : String])
            
        }else{
            finished_dictionary.append(dictionary as! [String : String])
            
        }
        
        //finished_dictionary.append(dictionaries as! [String : String])
        preferences.set(finished_dictionary, forKey: "notificationn")
        
        print(message)
        print(type)
        print(finished_dictionary)
        print(message_date)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    // [START refresh_token]
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            
            let preferences = UserDefaults.standard
            
            //Get login values
            let username = preferences.string(forKey: "usernameLogin")
            let password = preferences.string(forKey: "passwordLogin")
            let device_id_old = preferences.string(forKey: "device_id")
            preferences.set(refreshedToken, forKey: "device_id")
            
            let json = ["email_username":username, "password":password, "device_id": refreshedToken, "device_id_old": device_id_old]
            let url = "https://bm.prestanotifications.com/update_token.php"
            
            Alamofire.request(url, method: .post, parameters: json, encoding: JSONEncoding.default, headers:nil).responseJSON
                { response in
                    if let JSON = response.result.value as? NSDictionary{
                        print(JSON)
                    }
            }
            
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    // [START connect_to_fcm]
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return;
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    // [END connect_to_fcm]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the InstanceID token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
    }
    
    // [START connect_on_active]
    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFcm()
    }
    // [END connect_on_active]
    // [START disconnect_from_fcm]
    func applicationDidEnterBackground(_ application: UIApplication) {
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }
    // [END disconnect_from_fcm]
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            
            
            
            
            
            
            
            
            //print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]
// [START ios_10_data_message_handling]
extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}
// [END ios_10_data_message_handling]
