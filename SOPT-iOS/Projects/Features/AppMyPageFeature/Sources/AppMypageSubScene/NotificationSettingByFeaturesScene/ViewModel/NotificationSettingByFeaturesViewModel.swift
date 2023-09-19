//
//  NotificationSettingByFeaturesViewModel.swift
//  AppMyPageFeatureInterface
//
//  Created by Ian on 2023/09/19.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import AppMyPageFeatureInterface

public final class NotificationSettingByFeaturesViewModel: NotificationSettingByFeaturesViewModelType {
    // MARK: - Inputs
    
    public struct Input {
        let allOptInTapped: Driver<Bool>
        let partOptInTapped: Driver<Bool>
        let infoOptInTapped: Driver<Bool>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let updateSuccessed = PassthroughSubject<Bool, Never>()
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
        
        input.allOptInTapped
            .withUnretained(self)
            .sink { owner, isOn in
                owner.usecase.updateNotificationSettings(with: NotificationOptInModel(allOptIn: isOn))
            }.store(in: cancelBag)
        
        input.partOptInTapped
            .withUnretained(self)
            .sink { owner, isOn in
                owner.usecase.updateNotificationSettings(with: NotificationOptInModel(partOptIn: isOn))
            }.store(in: cancelBag)

        
        input.infoOptInTapped
            .withUnretained(self)
            .sink { owner, isOn in
                owner.usecase.updateNotificationSettings(with: NotificationOptInModel(newsOptIn: isOn))
            }.store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        let updateSuccess = self.usecase.updateSuccess
        
        updateSuccess
            .asDriver()
            .sink { isSuccced in
                output.updateSuccessed.send(isSuccced)
            }.store(in: cancelBag)
    }
}
