//
//  SoptlogToolTipViewModel.swift
//  SoptlogFeatureInterface
//
//  Created by 강윤서 on 3/26/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

import BaseFeatureDependency

public class SoptlogToolTipViewModel: SoptlogToolTipViewModelType {
    
    // MARK: - Properties

    private var cancelBag = CancelBag()

    // MARK: - Inputs
    
    public struct Input {
        let dismissbuttonTap: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output { }
    
    // MARK: - SoptlogToolTipCoordinatable
    
    public var onDismissButtonTap: (() -> Void)?
    
    
    // MARK: - initialization
    
    public init(cancelBag: CancelBag = CancelBag()) {
        self.cancelBag = cancelBag
    }
}

extension SoptlogToolTipViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.dismissbuttonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onDismissButtonTap?()
            }.store(in: cancelBag)
        
        return output
    }
}
