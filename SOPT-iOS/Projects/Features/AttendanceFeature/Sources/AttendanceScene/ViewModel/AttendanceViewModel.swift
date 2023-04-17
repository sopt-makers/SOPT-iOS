//
//  AttendanceViewModel.swift
//  AttendanceFeature
//
//  Created by 김영인 on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain

public class AttendanceViewModel: ViewModelType {

    private let useCase: AttendanceUseCase
    private var cancelBag = CancelBag()
    
    // MARK: - Input
    
    public struct Input {
        
    }
    
    // MARK: - Output
    
    public struct Output {
        
    }
    
    public init(useCase: AttendanceUseCase) {
        self.useCase = useCase
    }
}

extension AttendanceViewModel {
    public func transform(from input: Input, cancelBag: Core.CancelBag) -> Output {
        let output = Output()
        
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        
    }
}
