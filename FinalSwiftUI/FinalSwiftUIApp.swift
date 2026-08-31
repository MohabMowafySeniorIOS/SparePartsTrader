//

import SwiftUI
import IQKeyboardManagerSwift
import SwiftUI
import FirebaseCore
import FirebaseCrashlytics
import UserNotifications
import FirebaseMessaging
import GoogleMaps
import UIKit
@main
struct FinalSwiftUIApp: App {
   
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var networkMonitor = NetworkMonitor()
    @StateObject private var appStatusManager = AppStatusManager.shared
    init() {
        UIView.appearance().overrideUserInterfaceStyle = .light
        GMSServices.provideAPIKey("YOUR_API_KEY")
    }
 
    @StateObject var languageManager = LanguageManager()
    @State private var refreshID = UUID()   // 🔁 used to simulate restart
    var body: some Scene {
        WindowGroup {
            Group {
                if let status = appStatusManager.status {
                    // Forced maintenance / update screen — takes over the whole
                    // app, no matter which screen the user was standing on.
                    UpdateStatusOverlayView(status: status)
                } else if networkMonitor.isConnected {
                    RootView()

                } else {
                    NoNetView(title: "Something went wrong! 🔧".localized, image: "Clip path group", Btn_Title: "Back To Home".localized)
                }
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.2)) // Background color
            .onAppear {
                    print("Monitoring network status...")
                }
                //.environmentObject(coordinator)
                .environmentObject(languageManager)
                
                .environment(\.layoutDirection, languageManager.layoutDirection)
          
        }
    }
    
    
}


class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        showIQkeyboard()
        FirebaseApp.configure()
        AppStatusManager.shared.startListening()

             UNUserNotificationCenter.current().delegate = self
             Messaging.messaging().delegate = self   // ✅ مهم

             UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                 print("Permission granted:", granted)
                 if granted {
                     DispatchQueue.main.async {
                         application.registerForRemoteNotifications()
                     }
                 }
             }
//        GMSServices.provideAPIKey(Google_Key)
//        GMSPlacesClient.provideAPIKey(Google_Key)
        return true
    }
    
    func showIQkeyboard(){
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.toolbarConfiguration.tintColor = UIColor.MainColor
        // IQKeyboardManager.shared.keyboardAppearance = .dark
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarConfiguration.previousNextDisplayMode = .alwaysShow
        IQKeyboardManager.shared.deepResponderAllowedContainerClasses.append(UIStackView.self)
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardConfiguration.overrideAppearance = true
    }
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Permission granted: \(granted)")
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

  
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  
        func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
            print("✅ FCM Token:", fcmToken ?? "nil")
            Helper.SaveFcmtoken(Fcmtoken: fcmToken ?? "")
            // ابعته للباك اند لو هتستهدف الجهاز
        }

        // ✅ APNs token (لازم على جهاز حقيقي)
        func application(_ application: UIApplication,
                         didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            Messaging.messaging().apnsToken = deviceToken
            print("✅ APNs token received")
        }

        // عشان يظهر في foreground
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.banner, .sound, .badge])
        }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
}


