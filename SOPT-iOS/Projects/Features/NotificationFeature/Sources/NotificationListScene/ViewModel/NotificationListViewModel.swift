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
    
    let filterList: [NotificationFilterType] = [.all, .entireTarget, .partTarget, .news]
    
    var page = 0
    
    // MARK: - Inputs
    
    public struct Input {
        let requestNotificationList: Driver<Void>
        let naviBackButtonTapped: Driver<Void>
        let cellTapped: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        var notificationList = PassthroughSubject<[NotificationListModel], Never>()
    }
    
    // MARK: - NotificationCoordinatable
    
    public var onNaviBackButtonTap: (() -> Void)?
    public var onNotificationTap: (() -> Void)?
    
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
        
        input.requestNotificationList
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
            .sink { owner, _ in
                owner.onNotificationTap?()
            }.store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.notificationList
            .sink { notificationList in
                output.notificationList.send(notificationList)
            }.store(in: cancelBag)
    }
}
