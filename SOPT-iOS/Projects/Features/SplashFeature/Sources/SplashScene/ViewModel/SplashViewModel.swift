//
//  SplashViewModel.swift
//  Presentation
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain
import BaseFeatureDependency
import SplashFeatureInterface

public class SplashViewModel: SplashViewModelType {
    
    // MARK: - SplashCoordinatable
    
    // MARK: - Trigger
    
    public var onNoticeSkipped: (() -> Void)?
    public var onNoticeExist: ((AppNoticeModel) -> Void)?
    public var onOptionalNoticeExist: ((AppNoticeModel) -> Void)?
    public var finished: (() -> Void)?
    
    // MARK: - Properties
    
    private let coordinator: AnyCoordinatorObject
    private let useCase: SplashUseCase
    private var cancelBag = CancelBag()
    
    // MARK: - Inputs
    
    public struct Input { }
    
    // MARK: - Outputs
    
    public struct Output { }
    
    // MARK: - init
    
    public init(useCase: SplashUseCase, coordinator: Coordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
}

extension SplashViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        bindOutput(output: output, cancelBag: cancelBag)
        useCase.getAppNotice()
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.needUpdate
            .withUnretained(self)
            .receive(on: DispatchQueue.main)
            .sink { owner, updateType in
                switch updateType {
                case .forcedUpdate(let appNoticeModel):
                    owner.onNoticeExist?(appNoticeModel)
                case .optionalUpdate(let appNoticeModel):
                    owner.onOptionalNoticeExist?(appNoticeModel)
                case .none:
                    owner.onNoticeSkipped?()
                case .networkError(let error):
                    print("업데이트 상태 확인 중 에러가 발생했습니다.")
                    owner.showNetworkAlert()
                }
            }.store(in: cancelBag)
    }

    private func showNetworkAlert() {
        AlertUtils.presentAlertVC(
            type: .titleDescription,
            theme: .main,
            title: I18N.Default.networkError,
            description: I18N.Default.networkErrorDescription,
            customButtonTitle: I18N.Default.ok,
            customAction:{ [weak self] in
                self?.useCase.getAppNotice()
            }
        )
    }
}
