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
import Network

public class SettingRepository {
    
    private let userId: Int = UserDefaultKeyList.Auth.userId ?? 0
    private let authService: AuthService
    private let stampService: StampService
    private let cancelBag = CancelBag()
    
    public init(authService: AuthService, stampService: StampService) {
        self.authService = authService
        self.stampService = stampService
    }
}

extension SettingRepository: SettingRepositoryInterface {
    public func resetStamp() -> Driver<Bool> {
        stampService.resetStamp(userId: userId)
            .map { $0 == 200 }
            .asDriver()
    }
}

extension SettingRepository: PasswordChangeRepositoryInterface {
    public func changePassword(password: String) -> AnyPublisher<Bool, Error> {
        authService.changePassword(password: password, userId: 12).map { statusCode in statusCode == 200 }
            .eraseToAnyPublisher()
    }
}
