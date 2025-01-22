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
        let viewDidLoad: Driver<Void>
        let playgroundSignInFinished: Driver<String>
        let googleLoginButtonTapped: Driver<Void>
        let appleLoginButtonTapped: Driver<Void>
        let signUpButtonTapped: Driver<Void>
        let loginHelpButtonTapped: Driver<Void>
        let visitorButtonTapped: Driver<Void>
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

extension SignInViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoad
            .sink { _ in
                UserDefaultKeyList.clearUserData()
            }.store(in: self.cancelBag)
        
        Publishers.Merge(
            input.googleLoginButtonTapped.map { OAuthProvider.google },
            input.appleLoginButtonTapped.map { OAuthProvider.apple }
        ).flatMap(useCase.login)
            .withUnretained(self)
            .sink { owner,  _ in
                print("로그인 성공했습니다.")
                // 홈화면 진입 시 두가지 토큰이 충돌함 (2025.01.18)
                // AS-IS: UserDefaultKeyList.Auth.appAccessToken
                // TO-BE: UserDefaultKeyList.CoreAuth.accessToken
                // 홈화면 진입 후 토큰 관리 로직을 AS-IS에서 TO-BE로 모두 변경 후 아래 코드 주석을 풀 것
//                owner.onSignInSuccess?(.loginSuccess)
            }.store(in: self.cancelBag)
        
        input.signUpButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onSignUpButtonTapped?()
            }.store(in: self.cancelBag)
        
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
        
        useCase.sideEffect
            .sink { event in
                print(event)
            }
            .store(in: self.cancelBag)
    }
}
