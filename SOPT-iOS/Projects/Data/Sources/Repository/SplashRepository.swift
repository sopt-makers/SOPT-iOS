//
//  SplashRepository.swift
//  Data
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain
import Network

public class SplashRepository {
    
    private let firebaseService: FirebaseService
    private let userService: UserService
    private let cancelBag = CancelBag()
    
    public init(service: FirebaseService, userService: UserService) {
        self.firebaseService = service
        self.userService = userService
    }
}

extension SplashRepository: SplashRepositoryInterface {
    public func getAppNotice() -> AnyPublisher<AppNoticeModel, Error> {
        firebaseService.getAppNotice().map { appNoticeEntity in
            appNoticeEntity.toDomain()
        }.eraseToAnyPublisher()
    }
    
    public func getCheckedRecommendUpdateVersion() -> String? {
        return UserDefaultKeyList.AppNotice.checkedAppVersion
    }
    
    public func registerPushToken(with token: String) -> AnyPublisher<Bool, Error> {
        userService.registerPushToken(with: token)
            .map {
                print("푸시", $0)
                
                return $0 == 200
            }
            .eraseToAnyPublisher()
    }
}
