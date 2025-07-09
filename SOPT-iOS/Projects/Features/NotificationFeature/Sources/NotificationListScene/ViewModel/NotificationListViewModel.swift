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
import BaseFeatureDependency

public class NotificationListViewModel: NotificationListViewModelType {
    
    // MARK: - Trigger
    
    public var onNaviBackButtonTap: (() -> Void)?
    public var onNotificationTap: ((String) -> Void)?
    
    // MARK: - Properties
    
    private let coordinator: AnyCoordinatorObject
    private let useCase: NotificationListUseCase
    private var cancelBag = CancelBag()
    
    let filterList: [NotificationFilterType] = [.all, .notice, .news]
    var notifications: [NotificationListModel] = [] // 리스트 뷰에서 snapshot을 사용하기 때문에 중복된 모델이 있으면 안 된다.
    
    private var selectedCategory: NotificationFilterType = .all
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
    
    // MARK: - init
    
    public init(useCase: NotificationListUseCase, coordinator: Coordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
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
                AmplitudeInstance.shared.track(eventType: .viewNotificationList)
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
                AmplitudeInstance.shared.track(eventType: .clickNotificationItem,
                                               eventProperties: [
                                                "notification_id": notification.notificationId,
                                                "send_timestamp": notification.createdAt,
                                                "contents": notification.content ?? "",
                                                "admin_category": notification.category ?? "",
                                                "title": notification.title
                                               ])
            }.store(in: cancelBag)
        
        input.readAllButtonTapped
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: true)
            .withUnretained(self)
            .sink { owner, _ in
                owner.useCase.readAllNotifications()
                AmplitudeInstance.shared.track(eventType: .clickReadAllButton)
            }.store(in: cancelBag)
        
        input.categoryCellTapped
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, index in
                guard owner.filterList.indices.contains(index) else { return }
                owner.selectedCategory = owner.filterList[index]
                let filtered = owner.filterNotifications(owner.notifications, by: owner.selectedCategory)
                output.notificationList.send(filtered)
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
                let filtered = owner.filterNotifications(owner.notifications, by: owner.selectedCategory)
                output.notificationList.send(filtered)
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
    
    private func filterNotifications(_ notifications: [NotificationListModel], by category: NotificationFilterType) -> [NotificationListModel] {
        switch category {
        case .all: return notifications
        case .notice:
            return notifications.filter {
                guard let category = $0.category else { return false }
                return category == NotificationFilterType.notice.serverKey
            }
        case .news:
            return notifications.filter {
                guard let category = $0.category else { return false }
                return category == NotificationFilterType.news.serverKey
            }
        }
    }
}
