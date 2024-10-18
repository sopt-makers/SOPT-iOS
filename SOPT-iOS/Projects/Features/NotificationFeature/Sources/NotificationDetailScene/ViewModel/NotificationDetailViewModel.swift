//
//  NotificationDetailViewModel.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

import BaseFeatureDependency
import NotificationFeatureInterface

public class NotificationDetailViewModel: NotificationDetailViewModelType {

    // MARK: - Properties
    
    private let useCase: NotificationDetailUseCase
    private var cancelBag = CancelBag()
    
    private var notificationId: String
    private var notification: NotificationDetailModel?
  
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let shortCutButtonTap: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        var notification = PassthroughSubject<NotificationDetailModel, Never>()
    }
    
    // MARK: - NotificationCoordinatable
    
    public var onShortCutButtonTap: ((ShortCutLink) -> Void)?
    
    // MARK: - init
  
    public init(useCase: NotificationDetailUseCase, notificationId: String) {
        self.useCase = useCase
        self.notificationId = notificationId
    }
}

// MARK: - Methods

extension NotificationDetailViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.useCase.getNotificationDetail(notificationId: owner.notificationId)
            }.store(in: cancelBag)
        
        input.shortCutButtonTap
            .withUnretained(self)
            .map { owner, _ -> Bool in
                if let deepLink = owner.notification?.deepLink,
                    let date = owner.notification?.createdAt {
                    if !owner.isToday(date.toDate()) && deepLink.hasSuffix("fortune") {
                        ToastUtils.showMDSToast(type: .alert, text: I18N.DailySoptune.dateErrorToastMessage)
                        return false
                    }
                }
                return true
            }
            .filter{ $0 }
            .withUnretained(self)
            .sink { owner, _ in
                guard let shortCutLink = owner.makeShortCutLink() else { return }
                owner.onShortCutButtonTap?(shortCutLink)
            }.store(in: cancelBag)
    
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.notificationDetail
            .withUnretained(self)
            .sink { owner, notificationDetail in
                output.notification.send(notificationDetail)
                owner.notification = notificationDetail
                owner.useCase.readNotification(notificationId: owner.notificationId)
            }.store(in: cancelBag)
        
        useCase.readSuccess
            .asDriver()
            .sink { readSuccess in
                print("읽음 처리: \(readSuccess)")
            }.store(in: cancelBag)
    }
    
    private func makeShortCutLink() -> ShortCutLink? {
        guard let notification else { return nil }
        
        if let webLink = notification.webLink, !webLink.isEmpty {
            return (url: webLink, isDeepLink: false)
        }
        
        if let deepLink = notification.deepLink, !deepLink.isEmpty {
            return (url: deepLink, isDeepLink: true)
        }
        
        return nil
    }
    
    private func isToday(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
    }
}
