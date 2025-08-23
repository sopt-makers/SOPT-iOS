//
//  CoreSignUpRequestTransform.swift
//  Data
//
//  Created by 장석우 on 3/27/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Networks
import Domain

extension SignUpModel {
    func toData() -> CoreSignUpRequestEntity {
        return CoreSignUpRequestEntity(
            phone: phone,
            token: token,
            authPlatform: provider.toData()
        )
    }
}

extension PlatformType {
    public func toDomain() -> OAuthProvider {
        switch self {
        case .apple: .apple
        case .google: .google
        }
    }
}

extension SocialAccountResultEntity {
    public func toDomain()-> OAuthProvider {
        self.platform.toDomain()
    }
}
