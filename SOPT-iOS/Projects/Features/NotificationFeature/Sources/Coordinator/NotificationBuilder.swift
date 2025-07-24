//
//  NotificationBuilder.swift
//  NotificationFeatureInterface
//
//  Created by Jae Hyun Lee on 5/27/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Core
import Domain
import BaseFeatureDependency
@_exported import NotificationFeatureInterface

public
final class NotificationBuilder {
    @Injected public var notificationListRepository: NotificationListRepositoryInterface
    @Injected public var notificationDetailRepository: NotificationDetailRepositoryInterface
    
    public init() { }
}

extension NotificationBuilder: NotificationFeatureBuildable {
    public func makeNotificationList(coordinator: Coordinator) -> NotificationListPresentable {
        let useCase = DefaultNotificationListUseCase(repository: notificationListRepository)
        let vm = NotificationListViewModel(useCase: useCase, coordinator: coordinator)
        let vc = NotificationListVC(viewModel: vm)
        return (vc, vm)
    }
    
    public func makeNotificationDetailVC(notificationId: String) -> NotificationDetailPresentable {
        let useCase = DefaultNotificationDetailUseCase(repository: notificationDetailRepository)
        let viewModel = NotificationDetailViewModel(useCase: useCase, notificationId: notificationId)
        let notificationDetailVC = NotificationDetailVC(viewModel: viewModel)
        
        return (notificationDetailVC, viewModel)
    }
}
