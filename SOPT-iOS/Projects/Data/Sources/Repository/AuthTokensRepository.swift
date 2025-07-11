//
//  AuthTokensRepository.swift
//  Data
//
//  Created by 장석우 on 7/4/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core
import Domain
import Networks

public struct LegacyAuthTokensRepository: AuthTokensRepositoryInterface {
    
    private let local: UserDefaults
    private let remote: ReissueService
    
    private static let accessTokenKey = "appAccessToken"
    private static let refreshTokenKey = "appRefreshToken"
    private static let playgroundTokenKey = "playgroundToken"
    private static let isActiveUserKey = "isActiveUser"
    
    public init(
        local: UserDefaults = .standard,
        remote: ReissueService
    ) {
        self.local = local
        self.remote = remote
        
    }
    
    @Sendable
    public func refresh(completion: @escaping (Result<Void, ReissueError>) -> Void) {
        guard let token = self.fetch() else {
            completion(.failure(.tokenNotFound))
            return
        }
        
        remote.reissuance(with: token) { signInEntity in
            if let signInEntity {
                self.save(signInEntity)
                completion(.success(()))
            } else {
                completion(.failure(.expiredToken))
            }
        }
    }
    
    public func fetch() -> AuthTokens? {
        guard let at = local.string(forKey: Self.accessTokenKey),
              let rt = local.string(forKey: Self.refreshTokenKey),
              let pt = local.string(forKey: Self.playgroundTokenKey)
        else { return nil }
        
        return LegacyTokensModel(
            accessToken: at,
            refreshToken: rt,
            playgroundToken: pt
        )
    }
    
    @Sendable
    public func save(_ tokens: AuthTokens) {
        guard let tokens = tokens as? SignInEntity else { return }
        local.set(tokens.accessToken, forKey: Self.accessTokenKey)
        local.set(tokens.refreshToken, forKey: Self.refreshTokenKey)
        local.set(tokens.playgroundToken, forKey: Self.playgroundTokenKey)
        local.set(tokens.status == .active, forKey: Self.isActiveUserKey)
    }
    
}
