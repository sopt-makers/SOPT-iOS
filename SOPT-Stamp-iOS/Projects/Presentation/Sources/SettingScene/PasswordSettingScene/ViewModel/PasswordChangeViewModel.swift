//
//  PasswordChangeViewModel.swift
//  Presentation
//
//  Created by sejin on 2022/12/26.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Combine

import Core
import Domain

public class PasswordChangeViewModel: ViewModelType {

    private let useCase: PasswordChangeUseCase
    private var cancelBag = CancelBag()
  
    // MARK: - Inputs
    
    public struct Input {
    
    }
    
    // MARK: - Outputs
    
    public struct Output {
    
    }
    
    // MARK: - init
  
    public init(useCase: PasswordChangeUseCase) {
        self.useCase = useCase
    }
}

extension PasswordChangeViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        // input,output 상관관계 작성
    
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
    
    }
}
