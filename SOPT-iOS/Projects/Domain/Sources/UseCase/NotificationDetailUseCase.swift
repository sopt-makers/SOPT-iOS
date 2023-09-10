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
    var readSuccess: PassthroughSubject<Bool, Error> { get }
    
    func readNotification(notificationId: Int)
}

public class DefaultNotificationDetailUseCase {
  
    private let repository: NotificationDetailRepositoryInterface
    private var cancelBag = CancelBag()
    
    public let readSuccess = PassthroughSubject<Bool, Error>()
  
    public init(repository: NotificationDetailRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultNotificationDetailUseCase: NotificationDetailUseCase {
    
    public func readNotification(notificationId: Int) {
        repository.readNotification(notificationId: notificationId)
            .sink { [weak self] readSuccess in
                self?.readSuccess.send(readSuccess)
            }.store(in: cancelBag)
    }
}
