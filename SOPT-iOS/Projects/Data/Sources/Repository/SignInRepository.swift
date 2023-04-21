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
    public func requestSignIn(token: String) -> AnyPublisher<Bool, Error> {
        authService.signIn(token: token)
            .catch ({ error in
                guard
                    let error = error as? SOPTAPPError,
                    case .network(let statusCode) = error,
                    statusCode == 400
                else {
                    return self.userService.reissuance()
                }
                // NOTE: (@준호) 플그 미등록 + 비활동 유저의 경우 임시로 accessToken 빈 스트링 부여
                // 자동로그인 시 활용하기 위함
                UserDefaultKeyList.Auth.appAccessToken = ""
                return Fail(error: error).eraseToAnyPublisher()
            })
            .map { entity in
                UserDefaultKeyList.Auth.appAccessToken = entity.accessToken
                UserDefaultKeyList.Auth.appRefreshToken = entity.refreshToken
                UserDefaultKeyList.Auth.playgroundToken = entity.playgroundToken
                UserDefaultKeyList.Auth.isActiveUser = entity.status == .active
                ? true
                : false
                return true
            }
            .withUnretained(self)
            .flatMap { owner, isSuccessed in
                guard isSuccessed else {
                    return Driver(Just(false))
                }
                return owner.fetchSoptampUser()
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchSoptampUser() -> AnyPublisher<Bool, Never> {
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
