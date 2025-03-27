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

public class SignInViewModel_Refactor: SignInViewModelType_Refactor {
    
    private let useCase: SignInUseCase
    private var cancelBag = CancelBag()
  
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let googleLoginButtonTapped: Driver<Void>
        let appleLoginButtonTapped: Driver<Void>
        let loginHelpButtonTapped: Driver<Void>
        let visitorButtonTapped: Driver<Void>
        let signUpButtonTapped: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
    }
    
    // MARK: - SignInCoordinating
    
    public var onSignInSuccess: ((SiginInHandleableType) -> Void)?
    public var onLoginHelpButtonTapped: (() -> Void)?
    public var onVisitorButtonTapped: (() -> Void)?
    public var onSocialLoginFail: (() -> Void)?
    public var onSignUpButtonTapped: (() -> Void)?
    
    // MARK: - init
  
    public init(useCase: SignInUseCase) {
        self.useCase = useCase
    }
}

extension SignInViewModel_Refactor {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoad
            .sink { _ in
                UserDefaultKeyList.clearUserData()
            }.store(in: self.cancelBag)
        
        input.googleLoginButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onSocialLoginFail?() //TODO: 구글 로그인 로직
            }.store(in: self.cancelBag)
        
        input.appleLoginButtonTapped
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.useCase.login(with: .apple)
            }
            .withUnretained(self)
            .sink { owner, _ in
                owner.onSignInSuccess?(.loginSuccess)
            }
            .store(in: self.cancelBag)
        
        input.visitorButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onVisitorButtonTapped?()
            }.store(in: self.cancelBag)
        
        input.loginHelpButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onLoginHelpButtonTapped?()
            }.store(in: self.cancelBag)
        
        input.signUpButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onSignUpButtonTapped?()
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
