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
    var notificationList: PassthroughSubject<[NotificationListModel], Never> { get }
    var readSuccess: PassthroughSubject<Bool, Never> { get }
    
    func getNotificationList(page: Int)
    func readAllNotifications()
}

public class DefaultNotificationListUseCase {
  
    private let repository: NotificationListRepositoryInterface
    private var cancelBag = CancelBag()
    
    public let notificationList = PassthroughSubject<[NotificationListModel], Never>()
    public let readSuccess = PassthroughSubject<Bool, Never>()
  
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
    
    public func readAllNotifications() {
        repository.readAllNotifications()
            .sink { event in
                print("ReadAllNotifications State: \(event)")
            } receiveValue: { [weak self] readSuccess in
                self?.readSuccess.send(readSuccess)
            }.store(in: self.cancelBag)
    }
}
