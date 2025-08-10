//
//  SignInEntity.swift
//  Presentation
//
//  Created by devxsby on 2022/12/01.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Core

public struct SignInEntity: Codable {
    public let accessToken, refreshToken, playgroundToken: String
    public let status: UserStatus
}

public enum UserStatus: String, Codable {
    case active = "ACTIVE"
    case inactive = "INACTIVE"
    case visitor = "UNAUTHENTICATED"
}

extension SignInEntity: AuthTokens { }
