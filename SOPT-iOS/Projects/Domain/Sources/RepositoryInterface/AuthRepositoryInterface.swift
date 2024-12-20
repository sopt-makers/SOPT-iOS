//
//  AuthRepositoryInterface.swift
//  Domain
//
//  Created by 장석우 on 12/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine

// Apple, Google, Makers를 의존하지 않아도 소셜 로그인을 수행할 수 있도록 추상화
// Apple, Google, Makers 의존은 DefaultAuthRepository에서 수행

public protocol AuthRepositoryInterface {
    func requestSignIn(token: String) -> AnyPublisher<Bool, Error> 
    func oauthLogin(_ type: OAuthType) -> AnyPublisher<String, Error>
    func changeSocialAccount() -> AnyPublisher<Void, Error>
    func signUp(_ model: SignUpModel) -> AnyPublisher<Void, Error>
}
