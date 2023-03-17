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
        let emailTextChanged: Driver<String?>
        let passwordTextChanged: Driver<String?>
        let signInButtonTapped: Driver<SignInRequest>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        var isFilledForm = PassthroughSubject<Bool, Never>()
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
        
        input.emailTextChanged
            .compactMap({ $0 })
            .combineLatest(input.passwordTextChanged.compactMap({ $0 }))
            .sink { (email, password) in
                output.isFilledForm.send(!(email.isEmpty || password.isEmpty))
            }.store(in: self.cancelBag)
        
        input.signInButtonTapped
            .sink { signInRequest in
                self.useCase.requestSignIn(signInRequest: signInRequest)
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
