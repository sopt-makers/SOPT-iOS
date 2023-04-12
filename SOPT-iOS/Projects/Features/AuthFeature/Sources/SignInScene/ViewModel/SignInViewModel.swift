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
        let playgroundSignInFinished: Driver<String>
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
        
        input.playgroundSignInFinished
            .withUnretained(self)
            .sink { owner, token in
                owner.useCase.requestSignIn(token: token)
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
