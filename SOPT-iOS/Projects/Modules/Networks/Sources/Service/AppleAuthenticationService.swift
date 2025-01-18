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

import Domain

public protocol AuthenticationService {
    func getIdentityToken() -> AnyPublisher<String, CoreAuthError>
}

public final class DefaultAppleAuthenticationService: AuthenticationService {
    
    public init() {}
    
    private let authorizationController: ASAuthorizationController = {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        return ASAuthorizationController(authorizationRequests: [request])
    }()
    
    private lazy var proxy = ASAuthorizationControllerProxy.proxy(for: authorizationController)
    
    public func getIdentityToken() -> AnyPublisher<String, CoreAuthError> {
        performRequests()
            .tryMap {
                guard let credential = $0.credential as? ASAuthorizationAppleIDCredential,
                      let idToken = credential.identityToken
                else { throw CoreAuthError.apple(.credentialFail) }
                
                guard let idTokenString = String(data: idToken, encoding: .utf8)
                else { throw CoreAuthError.apple(.encodedFail) }
                
                return idTokenString
            }
            .mapError {
                if let err = $0 as? CoreAuthError { return err }
                else { return CoreAuthError.unknown($0) }
            }
            .eraseToAnyPublisher()
    }
}

extension DefaultAppleAuthenticationService {
    private func performRequests() -> AnyPublisher<ASAuthorization, CoreAuthError> {
        authorizationController.presentationContextProvider = proxy
        authorizationController.performRequests()
        return proxy.didComplete
            .mapError {
                CoreAuthError.apple($0)
            }.eraseToAnyPublisher()
    }
}
