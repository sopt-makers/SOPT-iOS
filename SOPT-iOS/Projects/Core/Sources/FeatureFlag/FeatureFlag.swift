//
//  FeatureFlag.swift
//  Core
//
//  Created by 장석우 on 7/12/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct FeatureFlag { }

//MARK: - Auth

extension FeatureFlag {

    public enum Auth {
        case legacy // 플그 기반 인증 방식
        case new // 인증 중앙화
    }

    public static var auth: Auth = .legacy
}

//TODO: - 추후 CoordinatorFeatureFlag 여기로 위치 변경
