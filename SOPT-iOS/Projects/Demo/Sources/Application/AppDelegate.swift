//
//  AppDelegate.swift
//  ProjectDescriptionHelpers
//
//  Created by 양수빈 on 2022/10/01.
//

import UIKit

import Networks
import Core
import BaseFeatureDependency

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var appLifecycleAdapter = AppLifecycleAdapter()
    
    static var didLaunchFromRemoteNotification = false

    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // AppLifeCycleAdapter에서 @Injected를 사용하기에 registerDependencies를 먼저 호출한다.
        //
        registerDependencies()
        configureAppLifecycleAdapter()
        Firebase.configure()
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

// MARK: - Sentry & APNs

extension AppDelegate {
    private func configureAppLifecycleAdapter() {
        self.appLifecycleAdapter.prepare()
    }

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
}
