//
//  DailySoptuneResultViewModel.swift
//  DailySoptuneFeature
//
//  Created by Jae Hyun Lee on 9/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

import DailySoptuneFeatureInterface

public class DailySoptuneResultViewModel: DailySoptuneResultViewModelType {
    
    // MARK: - Properties

    private let useCase: DailySoptuneUseCase
    private var cancelBag = CancelBag()
    
    // MARK: - Inputs
    
    public struct Input {
    }
    
    // MARK: - Outputs
    
    public struct Output {
    }
    
    // MARK: - Initialization
    
    public init(useCase: DailySoptuneUseCase) {
        self.useCase = useCase
    }
}

extension DailySoptuneResultViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
    }
}
