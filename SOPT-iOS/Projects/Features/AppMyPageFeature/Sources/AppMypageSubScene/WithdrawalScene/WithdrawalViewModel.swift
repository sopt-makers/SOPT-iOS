//
//  WithDrawalViewModel.swift
//  Presentation
//
//  Created by Junho Lee on 2023/01/12.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core
import Domain

public class WithdrawalViewModel: ViewModelType {

    private let useCase: SettingUseCase
    private var cancelBag = CancelBag()
    
    // MARK: - Inputs
    
    public struct Input {
        let withdrawalButtonTapped: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        var withdrawalSuccessed = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - init
  
    public init(useCase: SettingUseCase) {
        self.useCase = useCase
    }
}

extension WithdrawalViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.withdrawalButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.useCase.withdrawal()
            }.store(in: cancelBag)
    
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.withdrawalSuccess.asDriver()
            .sink { success in
                output.withdrawalSuccessed.send(success)
            }.store(in: self.cancelBag)
    }
}
