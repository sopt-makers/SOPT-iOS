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
import Networks

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
    
    public func requestSignIn(token: String) -> AnyPublisher<SignInModel, Error> {
        return authService.signIn(token: token)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func fetchSoptampUser() -> AnyPublisher<Bool, Never> {
        return userService.fetchSoptampUser()
            .replaceError(
                with: .init(
                    nickname: "닉네임 설정 오류",
                    profileMessage: "설정된 한 마디가 없습니다.",
                    points: 0
                ))
            .handleEvents(receiveOutput: { entity in
                UserDefaultKeyList.User.soptampName = entity.nickname
                UserDefaultKeyList.User.sentence = entity.profileMessage ?? "설정된 한 마디가 없습니다."
            })
            .map { _ in
                return true
            }
            .eraseToAnyPublisher()
    }
}
