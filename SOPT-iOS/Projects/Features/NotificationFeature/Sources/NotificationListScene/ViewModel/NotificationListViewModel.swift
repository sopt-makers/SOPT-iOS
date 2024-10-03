//
//  NotificationListViewModel.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/14.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

import NotificationFeatureInterface

public class NotificationListViewModel: NotificationListViewModelType {
    
    // MARK: - Properties
    
    private let useCase: NotificationListUseCase
    private var cancelBag = CancelBag()
    
    let filterList: [NotificationFilterType] = [.all, .notice, .news]
    var notifications: [NotificationListModel] = [] // 리스트 뷰에서 snapshot을 사용하기 때문에 중복된 모델이 있으면 안 된다.
    
    var page = 0
    var isPaging = false
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let requestNotifications: Driver<Void>
        let naviBackButtonTapped: Driver<Void>
        let cellTapped: Driver<Int>
        let readAllButtonTapped: Driver<Void>
        let categoryCellTapped: Driver<Int>
        let refreshRequest: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        var notificationList = PassthroughSubject<[NotificationListModel], Never>()
        var filterList = PassthroughSubject<[NotificationFilterType], Never>()
        var refreshLoading = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - NotificationCoordinatable
    
    public var onNaviBackButtonTap: (() -> Void)?
    public var onNotificationTap: ((String) -> Void)?
    
    // MARK: - init
    
    public init(useCase: NotificationListUseCase) {
        self.useCase = useCase
    }
}

// MARK: - Methods

extension NotificationListViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                output.filterList.send(owner.filterList)
            }.store(in: cancelBag)
        
        input.requestNotifications
            .withUnretained(self)
            .sink { owner, _ in
                owner.useCase.getNotificationList(page: owner.page)
            }.store(in: cancelBag)
        
        input.naviBackButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackButtonTap?()
            }.store(in: cancelBag)
        
        input.cellTapped
            .withUnretained(self)
            .sink { owner, index in
                let notification = owner.notifications[index]
                owner.onNotificationTap?(notification.notificationId)
                owner.read(index: index)
                output.notificationList.send(self.notifications)
            }.store(in: cancelBag)
        
        input.readAllButtonTapped
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: true)
            .withUnretained(self)
            .sink { owner, _ in
                owner.useCase.readAllNotifications()
            }.store(in: cancelBag)
        
        input.categoryCellTapped
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, index in
                print(index)
            }.store(in: cancelBag)
        
        input.refreshRequest
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: true)
            .withUnretained(self)
            .sink { owner, _ in
                if !owner.isPaging {
                    owner.notifications.removeAll()
                    owner.page = 0
                    owner.useCase.getNotificationList(page: owner.page)
                    return
                }
                output.refreshLoading.send(false)
            }.store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.notificationList
            .asDriver()
            .withUnretained(self)
            .sink { owner, notificationList in
                owner.removeDuplicatesAndUpdateNotifications(contentsOf: notificationList)
                output.notificationList.send(self.notifications)
                owner.endPaging(isEmptyResponse: notificationList.isEmpty)
                output.refreshLoading.send(false)
            }.store(in: cancelBag)
        
        useCase.readSuccess
            .asDriver()
            .withUnretained(self)
            .sink { owner, readSuccess in
                print("모든 알림 읽음 처리: \(readSuccess)")
                if readSuccess {
                    owner.notifications = owner.notifications.map {
                        var notification = $0
                        notification.isRead = true
                        return notification
                    }
                    output.notificationList.send(owner.notifications)
                }
            }.store(in: cancelBag)
    }
    
    private func removeDuplicatesAndUpdateNotifications(contentsOf notifications: [NotificationListModel]) {
        let temp = self.notifications + notifications
        self.notifications = temp.uniqued()
    }
    
    func startPaging() {
        self.isPaging = true
        self.page += 1
    }
    
    private func endPaging(isEmptyResponse: Bool) {
        self.isPaging = false
        if isEmptyResponse && self.page > 0 {
            self.page -= 1
        }
    }
    
    private func read(index: Int) {
        self.notifications[index].isRead = true
    }
}
