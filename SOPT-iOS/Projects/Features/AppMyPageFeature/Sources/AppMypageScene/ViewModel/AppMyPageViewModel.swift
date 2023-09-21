//
//  AppMyPageViewModel.swift
//  AppMypageFeature
//
//  Created by Ian on 2023/04/15.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import AppMyPageFeatureInterface

public final class AppMyPageViewModel: MyPageViewModelType {
    
    // MARK: - Inputs
    
    public struct Input {
        let viewWillAppear: Driver<Void>
        let alertSwitchTapped: Driver<Bool>
        let resetButtonTapped: Driver<Bool>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let resetSuccessed = PassthroughSubject<Bool, Never>()
        let originNotificationIsAllowed = PassthroughSubject<Bool, Never>()
        let alertSettingOptInEditedResult = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - MyPageCoordinatable
    
    private let useCase: AppMyPageUseCase
    
    public init(useCase: AppMyPageUseCase) {
        self.useCase = useCase
    }
}

extension AppMyPageViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)

        input.viewWillAppear
            .withUnretained(self)
            .sink { owner, _ in
                self.useCase.fetchUserNotificationIsAllowed()
            }.store(in: cancelBag)
        
        input.alertSwitchTapped
            .withUnretained(self)
            .sink { owner, isOn in
                owner.useCase.optInPushNotificationInGeneral(to: isOn)
            }.store(in: cancelBag)

        input.resetButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.useCase.resetStamp()
            }.store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        self.useCase
            .originUserNotificationIsAllowedStatus
            .asDriver()
            .sink { isAllowed in
                output.originNotificationIsAllowed.send(isAllowed)
            }.store(in: cancelBag)
        
        self.useCase
            .resetSuccess
            .asDriver()
            .sink { success in
                output.resetSuccessed.send(success)
            }.store(in: cancelBag)
        
        self.useCase
            .optInPushNotificationResult
            .asDriver()
            .sink { isOn in
                output.alertSettingOptInEditedResult.send(isOn)
            }.store(in: cancelBag)
    }
}
