//
//  ASAuthorizationControllerProxy.swift
//  Networks
//
//  Created by 장석우 on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import AuthenticationServices
import Combine
import Foundation

final class ASAuthorizationControllerProxy: NSObject {
    
    private let presentationWindow: UIWindow = UIWindow()
    public let didComplete = PassthroughSubject<ASAuthorization, OAuthError>()
    
    private override init() {}
    
    static func proxy(for object: ASAuthorizationController) -> Self {
        let owner = Self()
        object.delegate = owner
        return owner
    }
}

extension ASAuthorizationControllerProxy: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        didComplete.send(authorization)
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: any Error
    ) {
        didComplete.send(completion: .failure(.unauthorized(error)))
    }
}

extension ASAuthorizationControllerProxy: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        presentationWindow
    }
}
