//
//  AuthTokens.swift
//  Core
//
//  Created by 장석우 on 7/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public protocol AuthTokens: Encodable {
    var accessToken: String { get }
    var refreshToken: String { get }
}

public enum ReissueError: Error {
    case tokenNotFound
    case expiredToken
}
