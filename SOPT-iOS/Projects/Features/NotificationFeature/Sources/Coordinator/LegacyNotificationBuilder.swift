//
//  LegacyNotificationBuilder.swift
//  NotificationFeatureInterface
//
//  Created by Junho Lee on 2023/06/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import NotificationFeatureInterface

public
final class LegacyNotificationBuilder {
    @Injected public var notificationListRepository: NotificationListRepositoryInterface
    @Injected public var notificationDetailRepository: NotificationDetailRepositoryInterface
    
    public init() { }
}

extension LegacyNotificationBuilder: LegacyNotificationFeatureBuildable {
    public func makeNotificationList() -> LegacyNotificationListPresentable {
        let useCase = DefaultNotificationListUseCase(repository: notificationListRepository)
        let vm = NotificationListViewModel(useCase: useCase)
        let vc = NotificationListVC(viewModel: vm)
        return (vc, vm)
    }
    
    public func makeNotificationDetailVC(notificationId: String) -> LegacyNotificationDetailPresentable {
        let useCase = DefaultNotificationDetailUseCase(repository: notificationDetailRepository)
        let viewModel = NotificationDetailViewModel(useCase: useCase, notificationId: notificationId)
        let notificationDetailVC = NotificationDetailVC(viewModel: viewModel)
        
        return (notificationDetailVC, viewModel)
    }
}
