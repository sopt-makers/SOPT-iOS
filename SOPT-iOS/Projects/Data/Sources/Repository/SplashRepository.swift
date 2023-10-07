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
import Networks

public class SplashRepository {
    
    private let firebaseService: FirebaseService
    private let cancelBag = CancelBag()
    
    public init(service: FirebaseService) {
        self.firebaseService = service
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
}
