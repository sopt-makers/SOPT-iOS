//
//  AppleAuthService.swift
//  Networks
//
//  Created by 장석우 on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import AuthenticationServices
import Combine
import Foundation

public enum OAuthError: Error {
    case unauthorized(Error)
    case encodedFail
    case unknown(Error)
}

public protocol OAuthService {
    func getIdentityToken() -> AnyPublisher<String, OAuthError>
}

public final class AppleOAuthService: OAuthService {
    
    public init() {}
    
    private let authorizationController: ASAuthorizationController = {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        return ASAuthorizationController(authorizationRequests: [request])
    }()
    
    private lazy var proxy = ASAuthorizationControllerProxy.proxy(for: authorizationController)
    
    public func getIdentityToken() -> AnyPublisher<String, OAuthError> {
        performRequests()
            .tryMap {
                guard let credential = $0.credential as? ASAuthorizationAppleIDCredential,
                      let idToken = credential.identityToken,
                      let idTokenString = String(data: idToken, encoding: .utf8)
                else { throw OAuthError.encodedFail }
                
                return idTokenString
            }
            .mapError {
                if let err = $0 as? OAuthError { return err }
                else { return OAuthError.unknown($0) }
            }
            .eraseToAnyPublisher()
    }
}

extension AppleOAuthService {
    private func performRequests() -> AnyPublisher<ASAuthorization, OAuthError> {
        authorizationController.presentationContextProvider = proxy
        authorizationController.performRequests()
        return proxy.didComplete.eraseToAnyPublisher()
    }
}
