//
//  NotificationHandler.swift
//  RootFeature
//
//  Created by sejin on 2023/10/05.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import UserNotifications
import Combine

import BaseFeatureDependency
import Core

public final class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    
    public let deepLink = CurrentValueSubject<DeepLinkComponentsExecutable?, Never>(nil)
    @Published var notificationId: String?
    private let parser = DeepLinkParser()
    
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
        
        guard let payload = NotificationPayload(dictionary: userInfo) else { return }
        guard payload.hasLink else {
            self.deepLink.send(makeComponentsForEmptyLink(notificationId: ""))  // TODO: 푸시 알림 페이로드에 notificationId가 생기면 여기에 넣기
            return
        }
        
        if payload.hasDeepLink {
            self.parseDeepLink(with: payload.aps.deepLink)
        }
    }
}

extension NotificationHandler {
    private func parseDeepLink(with deepLink: String?) {
        guard let deepLink else { return }

        do {
            let deepLinkData = try parser.parse(with: deepLink)
            let deepLinkComponents = DeepLinkComponents(deepLinkData: deepLinkData)
            self.deepLink.send(deepLinkComponents)
        } catch {
            DispatchQueue.main.async {
                AlertUtils.presentAlertVC(type: .networkErr, title: I18N.DeepLink.updateAlertTitle,
                                          description: I18N.DeepLink.updateAlertDescription,
                                          customButtonTitle: I18N.DeepLink.updateAlertButtonTitle)
            }
        }
    }
    
    private func makeComponentsForEmptyLink(notificationId: String) -> DeepLinkComponents? {
        let deepLinkData = try? parser.parse(with: "home/notification/detail?id=\(notificationId)")
        return DeepLinkComponents(deepLinkData: deepLinkData)
    }
    
    public func clearNotificationRecord() {
        self.notificationId = nil
        self.deepLink.send(nil)
    }
}
