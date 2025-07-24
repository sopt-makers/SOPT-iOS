//
//  NotificationCoordinator.swift
//  NotificationFeatureInterface
//
//  Created by Jae Hyun Lee on 5/27/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import NotificationFeatureInterface
import Domain
import Core

public protocol NotificationCoordinatorDelegate: AnyObject {
    func notificationCoordinator(_ coordinator: NotificationCoordinator, to destination: NotificationCoordinatorDestination)
}

public final class NotificationCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    public weak var delegate: NotificationCoordinatorDelegate?

    private weak var navigationController: UINavigationController?
    private let factory: NotificationFeatureBuildable
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        factory: NotificationFeatureBuildable
    ) {
        self.navigationController = navigationController
        self.factory = factory
        super.init()
    }
    
    // MARK: - Coordinator Life Cycle

    public override func start() {
        showNotificationList()
    }

    // MARK: - Navigation
    
    private func showNotificationList() {
        var notificationList = factory.makeNotificationList(coordinator: self)
        
        notificationList.vm.onNaviBackButtonTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        notificationList.vm.onNotificationTap = { [weak self] notificationId in
            self?.showNotificationDetail(notificationId: notificationId)
        }
        
        navigationController?.pushViewController(notificationList.vc, animated: true)
    }

    public func showNotificationDetail(notificationId: String) {
        var notificationDetail = factory.makeNotificationDetailVC(notificationId: notificationId)
        
        notificationDetail.vm.onShortCutButtonTap = { [weak self] link in
            guard let self else { return }
            let url = link.url
            let destination: NotificationCoordinatorDestination = link.isDeepLink ? .deepLink(url: url) : .webLink(url: url)
            AmplitudeInstance.shared.track(eventType: .viewNotificationDetail, eventProperties: [
                "notification_id": notificationId,
                "open_method": link.isDeepLink ? "푸시알림" : "알림센터",
                "contain_deeplink": link.isDeepLink
            ])
            
            self.delegate?.notificationCoordinator(self, to: destination)
        }
        
        navigationController?.pushViewController(notificationDetail.vc, animated: true)
    }
}
