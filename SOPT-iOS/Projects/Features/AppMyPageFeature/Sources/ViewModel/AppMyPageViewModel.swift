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
        let resetButtonTapped: Driver<Bool>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        var resetSuccessed = PassthroughSubject<Bool, Never>()
    }
    
    private let useCase: AppMyPageUseCase
    
    public init(useCase: AppMyPageUseCase) {
        self.useCase = useCase
    }
}

extension AppMyPageViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.resetButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.useCase.resetStamp()
            }.store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        let resetSuccess = useCase.resetSuccess
        
        resetSuccess.asDriver()
            .sink { success in
                output.resetSuccessed.send(success)
            }.store(in: cancelBag)
    }
}
