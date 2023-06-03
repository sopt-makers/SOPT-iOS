//
//  AppDelegate.swift
//  ProjectDescriptionHelpers
//
//  Created by 양수빈 on 2022/10/01.
//

import UIKit

import Sentry
import FirebaseCore
import FirebaseMessaging
import Network
import Core

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureSentry()
        
        // FCM
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error = error {
                print(error)
            }
            
            granted ? print("FCM-알림 등록 완료") : print("FCM-알림 등록 실패")
        }
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application( _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application( _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {}
}

// MARK: - Sentry

extension AppDelegate {
    private func configureSentry() {
        SentrySDK.start { options in
            options.dsn = Config.Sentry.DSN
            options.enableCaptureFailedRequests = true
            options.attachScreenshot = true
            options.enableUserInteractionTracing = true
            options.attachViewHierarchy = true
            options.enableUIViewControllerTracing = true
            options.enableNetworkBreadcrumbs = true
            let httpStatusCodeRange = HttpStatusCodeRange(min: 400, max: 599)
            options.failedRequestStatusCodes = [ httpStatusCodeRange ]
            options.enableAutoBreadcrumbTracking = true
        }
    }
}

// MARK: - Firebase

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM-Token 서버로 전달 필요: \(fcmToken ?? "토큰을 받지 못함.."))")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        print("FCM-푸시 알림 페이로드: \(userInfo)")
        return([.badge, .banner, .list, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        print("FCM-푸시 알림 페이로드: \(userInfo)")
    }
}
