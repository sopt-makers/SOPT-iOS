//
//  SoptletterOnboardingEntity.swift
//  Networks
//
//  Created by 최주리 on 7/2/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

public struct SoptletterOnboardingEntity: Decodable {
    public let nickname: String
    public let isOnboarded: Bool
    public let currentGeneration: Int
}
