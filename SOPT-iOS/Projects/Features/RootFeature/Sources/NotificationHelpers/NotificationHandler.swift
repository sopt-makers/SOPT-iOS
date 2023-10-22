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
    
    @Published var notificationId: String?
    
    var hasNotificationId: Bool {
        notificationId != nil
    }
    
    public override init() {}
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        print("APNs 푸시 알림 페이로드: \(userInfo)")
        return([.badge, .banner, .list, .sound])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        print("APNs 푸시 알림 페이로드: \(userInfo)")
        
        guard let model = NotificationPayload(dictionary: userInfo) else { return }
        print("성공\(model)")
        guard model.hasLink else { return }
        
        let parser = DeepLinkParser()
        if let deepLink = model.aps.deepLink {
            let destination = parser.parse(with: deepLink)
            print("디버그", destination)
        }
    }
}

extension NotificationHandler {
    public func clearNotificationRecord() {
        self.notificationId = nil
    }
}
