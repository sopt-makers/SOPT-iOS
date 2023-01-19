//
//  AppNoticeRepository.swift
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

public class AppNoticeRepository {
    
    private let firebaseService: FirebaseService
    private let cancelBag = CancelBag()
    
    public init(service: FirebaseService) {
        self.firebaseService = service
    }
}

extension AppNoticeRepository: AppNoticeRepositoryInterface {
    public func getAppNotice() -> AnyPublisher<AppNoticeModel, Error> {
        firebaseService.getAppNotice().map { appNoticeEntity in
            appNoticeEntity.toDomain()
        }.eraseToAnyPublisher()
    }
    
    public func storeCheckedRecommendUpdateVersion(version: String) {
        UserDefaultKeyList.AppNotice.checkedAppVersion = version
    }
    
    public func getCheckedRecommendUpdateVersion() -> String? {
        return UserDefaultKeyList.AppNotice.checkedAppVersion
    }
}
