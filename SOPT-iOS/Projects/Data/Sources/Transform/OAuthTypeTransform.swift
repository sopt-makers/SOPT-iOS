//
//  OAuthTypeTransform.swift
//  Data
//
//  Created by 장석우 on 1/19/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Domain
import Networks

extension OAuthType {
    public func toData() -> PlatformType {
        switch self {
        case .google: .google
        case .apple: .apple
        }
    }
}
