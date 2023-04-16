//
//  AppMyPageRepository.swift
//  Data
//
//  Created by Ian on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Network
 
public final class AppMyPageRepository {
    private let stampService: StampService
    private let authService: AuthService
    private let userService: UserService

    public init(
        stampService: StampService,
        authService: AuthService,
        userService: UserService
    ) {
        self.stampService = stampService
        self.authService = authService
        self.userService = userService
    }
}

extension AppMyPageRepository: AppMyPageRepositoryInterface {
    public func resetStamp() -> Driver<Bool> {
        stampService
            .resetStamp()
            .map { $0 == 200 }
            .asDriver()
    }
    
    public func editSoptampSentence(sentence: String) -> AnyPublisher<Bool, Never> {
        return userService.editSentence(sentence: sentence)
            .handleEvents(receiveOutput: { entity in
                UserDefaultKeyList.User.sentence = entity.toDomain()
            })
            .map { _ in true }
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }
    
    public func editSoptampNickname(nickname: String) -> AnyPublisher<Bool, Never> {
        return userService.changeNickname(nickname: nickname)
            .map { _ in true }
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }
    
    public func withdrawalStamp() -> AnyPublisher<Bool, Never> {
        return authService.withdrawal()
            .handleEvents(receiveOutput: { status in
                if status == 200 {
                    UserDefaultKeyList.Auth.appAccessToken = nil
                    UserDefaultKeyList.Auth.appRefreshToken = nil
                    UserDefaultKeyList.Auth.playgroundToken = nil
                    UserDefaultKeyList.User.sentence = nil
                }
            })
            .map { _ in true }
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }
}
