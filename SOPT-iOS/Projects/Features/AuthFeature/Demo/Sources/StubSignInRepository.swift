//
//  StubUserService.swift
//  AuthFeatureTests
//
//  Created by 장석우 on 10/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine
import Foundation

import Domain
import AuthFeatureInterface

struct StubSignInRepository: SignInRepositoryInterface {
    func requestSignIn(token: String) -> AnyPublisher<Bool, Error> {
        Just(true).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
