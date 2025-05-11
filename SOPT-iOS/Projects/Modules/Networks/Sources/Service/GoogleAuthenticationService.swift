//
//  GoogleAuthenticationService.swift
//  Networks
//
//  Created by 장석우 on 5/1/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import GoogleSignIn

public final class GoogleOAuthService: OAuthService {
    
    public init() {}
    
    public func getIdentityToken() -> AnyPublisher<String, OAuthError> {
        Future<String, OAuthError> { promise in
            Task {
                guard let topVC = await UIApplication.getMostTopViewController() else {
                    promise(.failure(OAuthError.unknown(NSError())))
                    return
                }
                let signInResult = try? await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
                let user = try? await signInResult?.user.refreshTokensIfNeeded()
                guard let identityToken = user?.idToken?.tokenString else {
                    promise(.failure(OAuthError.unknown(NSError())))
                    return
                }
                promise(.success(identityToken))
            }
        }
        .eraseToAnyPublisher()
    }
}
