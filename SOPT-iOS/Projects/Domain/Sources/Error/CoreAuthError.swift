//
//  CoreAuthError.swift
//  Domain
//
//  Created by 장석우 on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public enum CoreAuthError: Error {
    case oAuthFail(OAuthProvider)
    case loginFail
    case signUpFail
    case unknown(Error)
}
