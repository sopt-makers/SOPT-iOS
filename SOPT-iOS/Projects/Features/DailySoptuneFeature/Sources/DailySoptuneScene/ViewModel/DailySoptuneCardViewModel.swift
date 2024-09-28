//
//  DailySoptuneCardViewModel.swift
//  DailySoptuneFeature
//
//  Created by Jae Hyun Lee on 9/28/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

import DailySoptuneFeatureInterface

public final class DailySoptuneCardViewModel: DailySoptuneCardViewModelType {
    
    public var onGoToHomeButtonTapped: (() -> Void)?
    public var onBackButtonTapped: (() -> Void)?

    // MARK: - Properties
    
    private let useCase: DailySoptuneUseCase
    private var cancelBag = CancelBag()
    
    // MARK: - Inputs
    
    public struct Input {
        let goToHomeButtonTap: Driver<Void>
        let backButtonTap: Driver<Void>
    }
    
    // MARK: - Outpust
    
    public struct Output {
        
    }
    
    // MARK: - initialization
    
    public init(useCase: DailySoptuneUseCase) {
        self.useCase = useCase
    }
}

extension DailySoptuneCardViewModel {
    
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.goToHomeButtonTap
            .withUnretained(self)
            .sink { _ in
                self.onGoToHomeButtonTapped?()
            }.store(in: cancelBag)
        
        input.backButtonTap
            .withUnretained(self)
            .sink { _ in
                self.onBackButtonTapped?()
            }.store(in: cancelBag)
        
        return output
    }
    
}
