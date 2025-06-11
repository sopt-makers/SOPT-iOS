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

public class SplashViewModel: ViewModelType {
    
    private let coordinator: SplashCoordinatable
    private let useCase: SplashUseCase
    private var cancelBag = CancelBag()
    
    // MARK: - Inputs
    
    public struct Input {
    }
    
    // MARK: - Outputs
    
    public struct Output {
        var appNoticeModel = PassthroughSubject<AppNoticeModel?, Error>()
    }
    
    // MARK: - init
    
    public init(useCase: SplashUseCase, coordinator: SplashCoordinatable) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    deinit {
        print("VM deinit")
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
        useCase.appNoticeModel
            .withUnretained(self)
            .sink { event in
                print("SplashViewModel - completion: \(event)")
            } receiveValue: { owner, appNoticeModel in
                guard let appNoticeModel = appNoticeModel else {
                    owner.coordinator.onNoticeSkipped?()
                    return
                }
                
                guard appNoticeModel.withError == false else {
                    owner.showNetworkAlert()
                    return
                }
                
                owner.coordinator.onNoticeExist?(appNoticeModel)
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
