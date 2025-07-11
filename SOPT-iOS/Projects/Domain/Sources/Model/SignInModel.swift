//
//  SignInModel.swift
//  Domain
//
//  Created by 장석우 on 7/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

public struct SignInModel {
    public let tokens: LegacyTokensModel
    public let status: UserType
    
    public init(tokens: LegacyTokensModel, status: UserType) {
        self.tokens = tokens
        self.status = status
    }
}
