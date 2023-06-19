//
//  NotificationListUseCase.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/14.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol NotificationListUseCase {

}

public class DefaultNotificationListUseCase {
  
    private let repository: NotificationListRepositoryInterface
    private var cancelBag = CancelBag()
  
    public init(repository: NotificationListRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultNotificationListUseCase: NotificationListUseCase {
  
}
