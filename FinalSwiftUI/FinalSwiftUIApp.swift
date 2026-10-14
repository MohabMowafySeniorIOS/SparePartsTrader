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
        UITextField.appearance().overrideUserInterfaceStyle = .light
        UITextView.appearance().overrideUserInterfaceStyle = .light
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
            .preferredColorScheme(.light)
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

        GMSServices.provideAPIKey(Google_Key)

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

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        FCMOrderNotificationRoute.enqueue(from: response.notification.request.content.userInfo)
        completionHandler()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
}

enum FCMOrderNotificationRoute {
    static let notificationOpened = Foundation.Notification.Name("FCMOrderNotificationOpened")
    private(set) static var pendingOrderID: String?
    private(set) static var pendingChat: (roomID: String, title: String)?

    private static let orderTypes: Set<String> = [
        "new_order", "new_offer", "offer_accepted", "rating_received",
        "problem_reported", "problem_resolved", "problem_rejected", "order_status", "payment_received"
    ]

    static func enqueue(from userInfo: [AnyHashable: Any]) {
        var payloads: [[String: Any]] = []
        if let payload = userInfo as? [String: Any] { payloads.append(payload) }
        if let payload = userInfo["data"] as? [String: Any] { payloads.append(payload) }
        if let rawData = userInfo["data"] as? String,
           let data = rawData.data(using: .utf8),
           let payload = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            payloads.append(payload)
        }

        let type = payloads.compactMap { $0["type"] as? String ?? $0["notification_type"] as? String }
            .first?.lowercased()
        guard let type else { return }

        let messageTypes: Set<String> = ["new_message", "message", "chat_message"]
        if messageTypes.contains(type) {
            let roomID = payloads.lazy.compactMap { payload -> String? in
                for key in ["chat_id", "chatId", "room_id", "roomId", "notify_id"] {
                    if let value = payload[key] as? String, !value.isEmpty { return value }
                    if let value = payload[key] as? Int { return String(value) }
                    if let value = payload[key] as? NSNumber { return value.stringValue }
                }
                return nil
            }.first
            guard let roomID else { return }
            let title = payloads.lazy.compactMap {
                $0["chat_title"] as? String ?? $0["sender_name"] as? String ?? $0["title"] as? String
            }.first ?? "Messages".localized

            DispatchQueue.main.async {
                pendingChat = (roomID, title)
                NotificationCenter.default.post(name: notificationOpened, object: nil)
            }
            return
        }

        guard orderTypes.contains(type) else { return }

        let id = payloads.lazy.compactMap { payload -> String? in
            for key in ["order_id", "orderId", "notify_id"] {
                if let value = payload[key] as? String, !value.isEmpty { return value }
                if let value = payload[key] as? Int { return String(value) }
                if let value = payload[key] as? NSNumber { return value.stringValue }
            }
            return nil
        }.first
        guard let id else { return }

        DispatchQueue.main.async {
            pendingOrderID = id
            NotificationCenter.default.post(name: notificationOpened, object: nil)
        }
    }

    static func takePendingOrderID() -> String? {
        defer { pendingOrderID = nil }
        return pendingOrderID
    }

    static func takePendingChat() -> (roomID: String, title: String)? {
        defer { pendingChat = nil }
        return pendingChat
    }
}
