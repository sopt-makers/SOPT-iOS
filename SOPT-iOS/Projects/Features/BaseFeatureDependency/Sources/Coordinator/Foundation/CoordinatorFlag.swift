//
//  CoordinatorFlag.swift
//  BaseFeatureDependency
//
//  Created by Jae Hyun Lee on 5/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

public enum CoordinatorFlag {
    case legacy
    case new
}

/// 배포용 스킴에서는 기존에 사용하던 레거시 Coor로,
/// 디버그용 스킴에서는 새로 생성한 Coor를 사용합니다.
extension Config {
    public static let coordinatorFlag: CoordinatorFlag = {
        #if DEV || PROD
        return .legacy
        #else
        return .legacy
        #endif
    }()
}
