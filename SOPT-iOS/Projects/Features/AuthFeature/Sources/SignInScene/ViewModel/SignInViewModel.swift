//
//  SignInViewModel.swift
//  Presentation
//
//  Created by devxsby on 2022/12/01.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core
import Domain

public class SignInViewModel: ViewModelType {

    private let useCase: SignInUseCase
    private var cancelBag = CancelBag()
  
    // MARK: - Inputs
    
    public struct Input {
        let signInButtonTapped: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        var isSignInSuccess = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - init
  
    public init(useCase: SignInUseCase) {
        self.useCase = useCase
    }
}

extension SignInViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.signInButtonTapped
            .sink { _ in
                // TODO: - 로그인 로직 구현
            }.store(in: self.cancelBag)
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        
        useCase.signInSuccess
            .sink { event in
                print("SignInViewModel: \(event)")
            } receiveValue: { isSignInSuccess in
                output.isSignInSuccess.send(isSignInSuccess)
            }.store(in: self.cancelBag)
    }
}
