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
                UserDefaultKeyList.Auth.isActiveUser = entity.status == "ACTIVE"
                ? true
                : false
                return true
            }
            .handleEvents(receiveOutput: { isSuccessed in
                guard isSuccessed else {
                    self.fetchSoptampUser()
                    return
                }
            })
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }
    
    private func fetchSoptampUser() {
        userService.fetchSoptampUser()
            .replaceError(
                with: .init(
                    nickname: "닉네임 설정 오류",
                    profileMessage: "설정된 한 마디가 없습니다.",
                    points: 0
                ))
            .sink { entity in
                UserDefaultKeyList.User.soptampName = entity.nickname
                UserDefaultKeyList.User.sentence = entity.profileMessage ?? "설정된 한 마디가 없습니다."
            }.store(in: cancelBag)
    }
}
