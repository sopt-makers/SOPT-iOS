//
//  NotificationSettingByFeaturesViewModel.swift
//  AppMyPageFeatureInterface
//
//  Created by Ian on 2023/09/19.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine
import Foundation

import Core
import Domain
import AppMyPageFeatureInterface

public final class NotificationSettingByFeaturesViewModel: NotificationSettingByFeaturesViewModelType {
    // MARK: - Inputs
    
    public struct Input {
        let viewWillAppear: Driver<Void>
        let allOptInTapped: Driver<Bool>
        let partOptInTapped: Driver<Bool>
        let infoOptInTapped: Driver<Bool>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let firstFetchedNotificationModel = PassthroughSubject<NotificationOptInModel, Never>()
        let updateSuccessed = PassthroughSubject<NotificationOptInModel, Never>()
    }
    
    private let usecase: NotificationSettingByFeaturesUsecase
    
    public init(usecase: NotificationSettingByFeaturesUsecase) {
        self.usecase = usecase
    }
}

extension NotificationSettingByFeaturesViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewWillAppear
            .withUnretained(self)
            .sink { owner, _ in
                owner.usecase.fetchNotificationSettings()
            }.store(in: cancelBag)

        input.allOptInTapped
            .throttle(for: 0.3, scheduler: RunLoop.main, latest: true)
            .withUnretained(self)
            .sink { owner, isOn in
                owner.usecase.updateNotificationSettings(with: NotificationOptInModel(allOptIn: isOn))
            }.store(in: cancelBag)
        
        input.partOptInTapped
            .throttle(for: 0.3, scheduler: RunLoop.main, latest: true)
            .withUnretained(self)
            .sink { owner, isOn in
                owner.usecase.updateNotificationSettings(with: NotificationOptInModel(partOptIn: isOn))
            }.store(in: cancelBag)

        
        input.infoOptInTapped
            .throttle(for: 0.3, scheduler: RunLoop.main, latest: true)
            .withUnretained(self)
            .sink { owner, isOn in
                owner.usecase.updateNotificationSettings(with: NotificationOptInModel(newsOptIn: isOn))
            }.store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        self.usecase
            .originNotificationInDetail
            .asDriver()
            .sink { notifcationOptInModel in
                output.firstFetchedNotificationModel.send(notifcationOptInModel)
            }.store(in: cancelBag)
        
        self.usecase
            .updateSuccess
            .asDriver()
            .sink { notifcationOptInModel in
                output.updateSuccessed.send(notifcationOptInModel)
            }.store(in: cancelBag)
    }
}
