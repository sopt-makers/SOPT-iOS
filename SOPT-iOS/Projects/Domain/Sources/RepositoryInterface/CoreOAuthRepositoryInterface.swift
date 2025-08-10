//
//  CoreOAuthRepositoryInterface.swift
//  Domain
//
//  Created by 장석우 on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

public protocol CoreOAuthRepositoryInterface {
    func getIdentityToken(from provider: OAuthProvider) -> AnyPublisher<String, CoreAuthError>
}
