import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
import flutter_local_notifications
import FirebaseMessaging
import UserNotifications
import FirebaseDynamicLinks

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
    GMSServices.provideAPIKey("AIzaSyBauBUw7ABmSkqpsx0yLM73Eqehz1guZS0")
    GeneratedPluginRegistrant.register(with: self)
          if #available(iOS 10.0, *) {
              UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
            }
          FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
              GeneratedPluginRegistrant.register(with: registry)
          }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }


    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

       Messaging.messaging().apnsToken = deviceToken
       super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    override  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.sound,.alert,.badge])
    }

//    override func application(_ application: UIApplication, continue userActivity: NSUserActivity,
//      restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//          if let incomingURL = userActivity.webpageURL {
//              let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
//                  // Handle the deep link here
//
//                  print(dynamicLink?.url?.absoluteString)
//                  print(error)
//
//              }
//              return linkHandled
//          }
//          return false
//      }
//
//   override  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//          let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(url) { (dynamicLink, error) in
//              // Handle the deep link here
//              let deepLink = dynamicLink?.url?.absoluteString
//
//              print(deepLink)
//
//          }
//          return linkHandled
//      }

    }
