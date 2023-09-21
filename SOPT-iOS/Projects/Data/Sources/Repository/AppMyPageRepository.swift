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
    private let userService: UserService

    public init(
        stampService: StampService,
        userService: UserService
    ) {
        self.stampService = stampService
        self.userService = userService
    }
}

extension AppMyPageRepository: AppMyPageRepositoryInterface {
    public func resetStamp() -> Driver<Bool> {
        self.stampService
            .resetStamp()
            .map { $0 == 200 }
            .asDriver()
    }
    
    public func getNotificationIsAllowed() -> Driver<Bool> {
        self.userService
            .getNotificationIsAllowed()
            .map(\.isOptIn)
            .asDriver()
    }
    
    public func optInPushNotificationInGeneral(to isOn: Bool) -> Driver<Bool> {
        self.userService
            .optInPushNotificationInGeneral(to: isOn)
            .map(\.isOptIn)
            .asDriver()
    }
}
