//
//  NotificationDetailViewModel.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

public class NotificationDetailViewModel: ViewModelType {

    // MARK: - Properties
    
    private let useCase: NotificationDetailUseCase
    private var cancelBag = CancelBag()
  
    // MARK: - Inputs
    
    public struct Input {
    
    }
    
    // MARK: - Outputs
    
    public struct Output {
    
    }
    
    // MARK: - init
  
    public init(useCase: NotificationDetailUseCase) {
        self.useCase = useCase
    }
}

// MARK: - Methods

extension NotificationDetailViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        // input,output 상관관계 작성
    
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
    
    }
}
