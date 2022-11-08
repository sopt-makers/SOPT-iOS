//
//  SampleViewModel.swift
//  Network
//
//  Created by Junho Lee on 2022/11/09.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core
import Domain

public class SampleViewModel: ViewModelType {

    private let useCase: SampleUseCase
    private var cancelBag = Set<AnyCancellable>()
  
    // MARK: - Inputs
    
    public struct Input {
    
    }
    
    // MARK: - Outputs
    
    public struct Output {
    
    }
    
    // MARK: - init
  
    public init(useCase: SampleUseCase) {
        self.useCase = useCase
    }
}

extension SampleViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        // input,output 상관관계 작성
    
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
    
    }
}
