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
    public let webLink = CurrentValueSubject<String?, Never>(nil)
    public let notificationLinkError = CurrentValueSubject<NotificationLinkError?, Never>(nil)
    
    private let deepLinkParser = DeepLinkParser()
    private let webLinkParser = WebLinkParser()
    
    public override init() {}
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        print("APNs 푸시 알림 페이로드: \(userInfo)")
        return([.badge, .banner, .list, .sound])
    }
    
    @MainActor
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        print("APNs 푸시 알림 페이로드: \(userInfo)")
        
        guard let payload = NotificationPayload(dictionary: userInfo) else { return }
        guard payload.hasLink else {
            self.deepLink.send(makeComponentsForEmptyLink(notificationId: payload.id))
            return
        }
        
        if payload.hasDeepLink {
            self.parseDeepLink(with: payload.deepLink)
        }
        
        if payload.hasWebLink {
            self.handleWebLink(with: payload.webLink)
        }
    }
    
    public func receive(deepLink: String) {
        self.parseDeepLink(with: deepLink)
    }
}

extension NotificationHandler {
    private func parseDeepLink(with deepLink: String?) {
        guard let deepLink else { return }
        
        do {
            let deepLinkData = try deepLinkParser.parse(with: deepLink)
            let deepLinkComponents = DeepLinkComponents(deepLinkData: deepLinkData)
            self.deepLink.send(deepLinkComponents)
        } catch {
            self.handleLinkError(error: error)
        }
    }
    
    private func makeComponentsForEmptyLink(notificationId: String) -> DeepLinkComponents? {
        let deepLinkData = try? deepLinkParser.parse(with: "home/notification/detail?id=\(notificationId)")
        return DeepLinkComponents(deepLinkData: deepLinkData)
    }
    
    private func handleWebLink(with webLink: String?) {
        guard let webLink else { return }
        do {
            let url = try webLinkParser.parse(with: webLink)
            self.webLink.send(url)
        } catch {
            self.handleLinkError(error: error)
        }
    }
    
    private func handleLinkError(error: Error) {
        guard let error = error as? NotificationLinkError else { return }
        self.notificationLinkError.send(error)
    }
    
    public func clearNotificationRecord() {
        self.deepLink.send(nil)
        self.webLink.send(nil)
        self.notificationLinkError.send(nil)
    }
}
