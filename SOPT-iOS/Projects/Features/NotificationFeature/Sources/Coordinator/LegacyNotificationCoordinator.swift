//
//  LegacyNotificationCoordinator.swift
//  NotificationFeatureInterface
//
//  Created by Junho Lee on 2023/06/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import BaseFeatureDependency
import NotificationFeatureInterface
import Domain

public
final class LegacyNotificationCoordinator: DefaultNotificationCoordinator {
    
    public var requestCoordinating: ((NotificationCoordinatorDestination) -> Void)?
    
    public var finishFlow: (() -> Void)?
    
    private let factory: LegacyNotificationFeatureBuildable
    private let router: LegacyRouter
    
    public init(router: LegacyRouter, factory: LegacyNotificationFeatureBuildable) {
        self.factory = factory
        self.router = router
    }
    
    public override func start() {
        showNotifcationList()
    }
    
    private func showNotifcationList() {
        var notificiationList = factory.makeNotificationList(coordinator: self)
        notificiationList.vm.onNaviBackButtonTap = { [weak self] in
            self?.router.popModule()
            self?.finishFlow?()
        }
        notificiationList.vm.onNotificationTap = { [weak self] notificationId in
            self?.showNotificationDetail(notificationId: notificationId)
        }
        
        AmplitudeInstance.shared.trackWithUserType(event: .clickAlarm)
        
        router.push(notificiationList.vc)
    }
    
    public func showNotificationDetail(notificationId: String) {
        var notificationDetail = factory.makeNotificationDetailVC(notificationId: notificationId)
        notificationDetail.vm.onShortCutButtonTap = { [weak self] link in
            let url = link.url
            
            let destination: NotificationCoordinatorDestination = link.isDeepLink ? .deepLink(url: url) : .webLink(url: url)
            AmplitudeInstance.shared.track(eventType: .viewNotificationDetail, eventProperties: [
                "notification_id": notificationId,
                "open_method": link.isDeepLink ? "푸시알림" : "알림센터",
                "contain_deeplink": link.isDeepLink
            ])
            
            self?.requestCoordinating?(destination)
        }
        
        router.push(notificationDetail.vc)
    }
}
