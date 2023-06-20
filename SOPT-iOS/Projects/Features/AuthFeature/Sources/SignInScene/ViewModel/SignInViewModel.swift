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

import AuthFeatureInterface

public class SignInViewModel: SignInViewModelType {
    
    private let useCase: SignInUseCase
    private var cancelBag = CancelBag()
  
    // MARK: - Inputs
    
    public struct Input {
        let playgroundSignInFinished: Driver<String>
        let visitorButtonTapped: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
    }
    
    // MARK: - SignInCoordinating
    
    public var onSignInSuccess: ((SiginInHandleableType) -> Void)?
    public var onVisitorButtonTapped: (() -> Void)?
    
    // MARK: - init
  
    public init(useCase: SignInUseCase) {
        self.useCase = useCase
    }
}

extension SignInViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.visitorButtonTapped
            .withUnretained(self)
            .sink { owner, token in
                owner.onVisitorButtonTapped?()
            }.store(in: self.cancelBag)
        
        input.playgroundSignInFinished
            .withUnretained(self)
            .sink { owner, token in
                owner.useCase.requestSignIn(token: token)
            }.store(in: self.cancelBag)
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.signInSuccess
            .removeDuplicates()
            .withUnretained(self)
            .sink { event in
                print("SignInViewModel: \(event)")
            } receiveValue: { (owner, isSignInSuccess) in
                owner.onSignInSuccess?(isSignInSuccess)
            }.store(in: self.cancelBag)
    }
}
