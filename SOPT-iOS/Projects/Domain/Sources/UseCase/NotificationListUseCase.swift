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
    var notificationList: PassthroughSubject<[NotificationListModel], Never> { get set }
    
    func getNotificationList(page: Int)
}

public class DefaultNotificationListUseCase {
  
    private let repository: NotificationListRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var notificationList = PassthroughSubject<[NotificationListModel], Never>()
  
    public init(repository: NotificationListRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultNotificationListUseCase: NotificationListUseCase {
    // TODO: 에러 핸들링 필요
    public func getNotificationList(page: Int) {
        repository.getNotificationList(page: page)
            .sink { event in
                print("GetNotificationList State: \(event)")
            } receiveValue: { [weak self] notificationListModel in
                self?.notificationList.send(notificationListModel)
            }.store(in: self.cancelBag)
    }
}
