//
//  SentenceEditViewModel.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/22.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core
import Domain

public class SentenceEditViewModel: ViewModelType {

    private let useCase: SentenceEditUseCase
    private var cancelBag = CancelBag()
  
    // MARK: - Inputs
    
    public struct Input {
    
    }
    
    // MARK: - Outputs
    
    public struct Output {
    
    }
    
    // MARK: - init
  
    public init(useCase: SentenceEditUseCase) {
        self.useCase = useCase
    }
}

extension SentenceEditViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        // input,output 상관관계 작성
    
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
    
    }
}
