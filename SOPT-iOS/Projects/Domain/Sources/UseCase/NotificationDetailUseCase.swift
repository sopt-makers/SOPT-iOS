//
//  NotificationDetailUseCase.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol NotificationDetailUseCase {

}

public class DefaultNotificationDetailUseCase {
  
    private let repository: NotificationDetailRepositoryInterface
    private var cancelBag = CancelBag()
  
    public init(repository: NotificationDetailRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultNotificationDetailUseCase: NotificationDetailUseCase {
  
}
