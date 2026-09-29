//
//  SoptletterProfileModel.swift
//  Domain
//
//  Created by 최주리 on 7/2/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

public struct SoptletterProfileModel {
    public let nickname: String
    public let isOnboarded: Bool
    public let currentGeneration: Int
    
    public init(nickname: String, isOnboarded: Bool, currentGeneration: Int) {
        self.nickname = nickname
        self.isOnboarded = isOnboarded
        self.currentGeneration = currentGeneration
    }
}
