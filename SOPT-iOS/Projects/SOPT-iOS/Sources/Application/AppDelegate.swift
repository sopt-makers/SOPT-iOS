//
//  AppDelegate.swift
//  ProjectDescriptionHelpers
//
//  Created by 양수빈 on 2022/10/01.
//

import UIKit

import Sentry

import Network
import Core

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureSentry()
        configureAPNs()
        registerDependencies()
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

// MARK: - Sentry & FCM

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
  
    private func configureAPNs() {
        UNUserNotificationCenter.current().delegate = self
    }
}

// MARK: - APNs

extension AppDelegate: UNUserNotificationCenterDelegate {
    /// APNs 등록 실패할 경우 호출되는 메서드
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs Failed to register for notifications: \(error.localizedDescription)")
    }
    
    /// APNs 등록 성공할 경우 호출되는 메서드
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        UserDefaultKeyList.User.pushToken = token
        print("APNs Device Token: \(token)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        print("APNs 푸시 알림 페이로드: \(userInfo)")
        return([.badge, .banner, .list, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        print("APNs 푸시 알림 페이로드: \(userInfo)")
    }
}
