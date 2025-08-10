//
//  CoreLoginTransform.swift
//  Data
//
//  Created by 장석우 on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension AuthTokensEntity {
    public func toDomain() -> AuthTokensModel {
        .init(accessToken: accessToken, refreshToken: refreshToken)
    }
}
