//
//  ChangeSocialResultEntity.swift
//  Networks
//
//  Created by 장석우 on 12/28/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Domain

public struct SocialAccountResultEntity: Decodable {
    let platform: PlatformType
}

extension SocialAccountResultEntity {
    public func toDomain()-> OAuthProvider {
        self.platform.toDomain()
    }
}

