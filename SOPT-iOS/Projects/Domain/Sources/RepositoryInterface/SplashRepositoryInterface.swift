//
//  SplashRepositoryInterface.swift
//  Domain
//
//  Created by 강윤서 on 7/8/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

public protocol SplashRepositoryInterface {
    func appStoreVersion() async throws -> String
    func forcedUpdateData() async throws -> ForceUpdateModel
    func optionalUpdateData() async throws -> AppNoticeModel
}
