//
//  PlatformType.swift
//  Networks
//
//  Created by 장석우 on 12/28/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Domain

public enum PlatformType: String, Codable {
    case google = "GOOGLE"
    case apple = "APPLE"
}

extension PlatformType {
    public func toDomain() -> OAuthProvider {
        switch self {
        case .apple: .apple
        case .google: .google
        }
    }
}
