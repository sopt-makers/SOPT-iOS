//
//  SignInRepository.swift
//  Data
//
//  Created by devxsby on 2022/12/01.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Combine

import Core

import Domain
import Network

public class SignInRepository {
    
    private let authService: AuthService
    private let userService: UserService
    private let cancelBag = CancelBag()
    
    public init(authService: AuthService, userService: UserService) {
        self.authService = authService
        self.userService = userService
    }
}

extension SignInRepository: SignInRepositoryInterface {
    
    public func requestSignIn(token: String) -> AnyPublisher<Bool, Never> {
        authService.signIn(token: token)
            .map { entity in
                UserDefaultKeyList.Auth.appAccessToken = entity.accessToken
                UserDefaultKeyList.Auth.appRefreshToken = entity.refreshToken
                UserDefaultKeyList.Auth.playgroundToken = entity.playgroundToken
                return true
            }
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }
}
