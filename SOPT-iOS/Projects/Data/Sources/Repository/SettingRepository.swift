//
//  SettingRepository.swift
//  Presentation
//
//  Created by 양수빈 on 2022/12/17.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Networks

public class SettingRepository {
    
    private let authService: AuthService
    private let stampService: StampService
    private let userService: UserService
    private let cancelBag = CancelBag()
    
    public init(authService: AuthService, stampService: StampService, userService: UserService) {
        self.authService = authService
        self.stampService = stampService
        self.userService = userService
    }
}

extension SettingRepository: SettingRepositoryInterface {
    
    public func resetStamp() -> Driver<Bool> {
        stampService.resetStamp()
            .map { $0 == 200 }
            .asDriver()
    }
    
    public func editSentence(sentence: String) -> AnyPublisher<Bool, Never> {
        return userService.editSentence(sentence: sentence)
            .handleEvents(receiveOutput: { entity in
                UserDefaultKeyList.User.sentence = entity.toDomain()
            })
            .map { _ in true }
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }
    
    public func withdrawal() -> AnyPublisher<Bool, Never> {
        return userService.withdraw()
            .handleEvents(receiveOutput: { status in
                if status == 200 {
                    UserDefaultKeyList.clearAllUserData()
                }
            })
            .map { _ in true}
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }
}
