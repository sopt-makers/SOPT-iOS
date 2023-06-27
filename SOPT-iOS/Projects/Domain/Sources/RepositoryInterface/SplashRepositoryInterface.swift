//
//  SplashRepositoryInterface.swift
//  Domain
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

public protocol SplashRepositoryInterface {
    func getAppNotice() -> AnyPublisher<AppNoticeModel, Error>
    func getCheckedRecommendUpdateVersion() -> String?
    func registerPushToken(with token: String) -> AnyPublisher<Bool, Error>
}
