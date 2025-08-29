//
//  AuthTokensRepositoryInterface.swift
//  Domain
//
//  Created by 장석우 on 7/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

public protocol AuthTokensRepositoryInterface {
    @Sendable func refresh(completion: @escaping (Result<Void, ReissueError>) -> Void)
    func fetch() -> AuthTokens?
    func save(_ tokens: AuthTokens)
    func delete()
}
