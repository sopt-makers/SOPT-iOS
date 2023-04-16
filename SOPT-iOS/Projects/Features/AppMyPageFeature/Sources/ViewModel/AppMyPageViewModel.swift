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

public final class AppMyPageViewModel: ViewModelType {
    // MARK: - Inputs
    
    public struct Input {
        
    }
    
    // MARK: - Outputs
    
    public struct Output {
        
    }
    
    public init() {
        
    }
}

extension AppMyPageViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        
    }
}
