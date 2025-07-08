//
//  SplashRepositoryInterface.swift
//  Domain
//
//  Created by 강윤서 on 7/8/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Combine

public protocol SplashRepositoryInterface {
    func appStoreVersion() async throws -> String?
    func minimumVersion() async throws -> ForceUpdateModel
}
