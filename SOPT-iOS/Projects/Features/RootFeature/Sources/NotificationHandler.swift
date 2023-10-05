//
//  NotificationHandler.swift
//  RootFeature
//
//  Created by sejin on 2023/10/05.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import UserNotifications
import Core

public final class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    
    public static let shared = NotificationHandler()
    
    @Published var notificationId: String?
    
    var hasNotificationId: Bool {
        notificationId != nil
    }
    
    private override init() {}
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        print("APNs 푸시 알림 페이로드: \(userInfo)")
        return([.badge, .banner, .list, .sound])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        print("APNs 푸시 알림 페이로드: \(userInfo)")
        notificationId = "알림 아이디"
    }
}
