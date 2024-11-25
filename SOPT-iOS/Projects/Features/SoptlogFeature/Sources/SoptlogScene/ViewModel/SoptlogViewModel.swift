//
//  SoptlogViewModel.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

import HomeFeatureInterface
import BaseFeatureDependency

public class SoptlogViewModel: SoptlogViewModelType {
    
    // MARK: - Inputs
    
    public struct Input { }
    
    // MARK: - Outputs
    
    public struct Output { }
    
    // MARK: - initialization
    
    public init() { }
}

extension SoptlogViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        return output
    }
}

