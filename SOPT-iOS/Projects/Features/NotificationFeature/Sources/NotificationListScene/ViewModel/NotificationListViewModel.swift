//
//  NotificationListViewModel.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/14.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

public class NotificationListViewModel: ViewModelType {

    // MARK: - Properties
    
    private let useCase: NotificationListUseCase
    private var cancelBag = CancelBag()
    
    let filterList: [NotificationFilterType] = [.all, .entireTarget, .partTarget, .news]
  
    // MARK: - Inputs
    
    public struct Input {
    
    }
    
    // MARK: - Outputs
    
    public struct Output {
    
    }
    
    // MARK: - init
  
    public init(useCase: NotificationListUseCase) {
        self.useCase = useCase
    }
}

// MARK: - Methods

extension NotificationListViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        // input,output 상관관계 작성
    
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
    
    }
}
