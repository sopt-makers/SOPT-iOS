//
//  SoptletterOnboardingTransform.swift
//  Data
//
//  Created by 최주리 on 7/2/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Domain
import Networks

extension SoptletterOnboardingEntity {
    func toDomain() -> SoptletterProfileModel {
        .init(nickname: nickname, isOnboarded: isOnboarded)
    }
}
