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

public class SplashViewModel: ViewModelType {

    private let useCase: AppNoticeUseCase
    private var cancelBag = CancelBag()
  
    // MARK: - Inputs
    
    public struct Input {

    }
    
    // MARK: - Outputs
    
    public struct Output {

    }
    
    // MARK: - init
  
    public init(useCase: AppNoticeUseCase) {
        self.useCase = useCase
    }
}

extension SplashViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
  
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {

    }
}
