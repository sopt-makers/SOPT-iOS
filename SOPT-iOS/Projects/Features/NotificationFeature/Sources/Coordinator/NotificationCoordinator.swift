//
//  NotificationCoordinator.swift
//  NotificationFeatureInterface
//
//  Created by Junho Lee on 2023/06/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import BaseFeatureDependency
import NotificationFeatureInterface
import Domain

public enum NotificationCoordinatorDestination {
    case deepLink(url: String)
}

public protocol NotificationCoordinatorOutput {
    var requestCoordinating: ((NotificationCoordinatorDestination) -> Void)? { get set }
}

public typealias DefaultNotificationCoordinator = DefaultCoordinator & NotificationCoordinatorOutput

public
final class NotificationCoordinator: DefaultNotificationCoordinator {
    
    public var requestCoordinating: ((NotificationCoordinatorDestination) -> Void)?
    
    public var finishFlow: (() -> Void)?
    
    private let factory: NotificationFeatureBuildable
    private let router: Router
    
    public init(router: Router, factory: NotificationFeatureBuildable) {
        self.factory = factory
        self.router = router
    }
    
    public override func start() {
        showNotifcationList()
    }
    
    private func showNotifcationList() {
        var notificiationList = factory.makeNotificationList()
        notificiationList.vm.onNaviBackButtonTap = { [weak self] in
            self?.router.popModule()
            self?.finishFlow?()
        }
        notificiationList.vm.onNotificationTap = { [weak self] notificationId in
            self?.showNotificationDetail(notificationId: notificationId)
        }
        router.push(notificiationList.vc)
    }
    
    public func showNotificationDetail(notificationId: Int) {
        var notificationDetail = factory.makeNotificationDetailVC(notificationId: notificationId)
        notificationDetail.vm.onShortCutButtonTap = { [weak self] link in
            let url = link.url
            
            if link.isDeepLink {
                let destination: NotificationCoordinatorDestination = .deepLink(url: url)
                self?.requestCoordinating?(destination)
                return
            }
            
            self?.router.presentSafari(url: url)
        }
        
        router.push(notificationDetail.vc)
    }
}
