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

public
final class NotificationCoordinator: DefaultCoordinator {
    
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
    
    public override func start(with option: DeepLinkOption?) {
        start()
        if case .deepLinkView(let components) = option {
            guard let targetView = components.popFirstView() else { return }
            switch targetView {
            case .Home.Notification.detail:
                guard let id = components.getQueryItemValue(name: "id"), let notificationId = Int(id) else { return }
                showNotificationDetail(notificationId: notificationId)
            default:
                return
            }
        }
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
        let notificationDetail = factory.makeNotificationDetailVC(notificationId: notificationId)
        router.push(notificationDetail)
    }
}
