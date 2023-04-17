//
//  AuthService.swift
//  Network
//
//  Created by Junho Lee on 2022/10/17.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

import Alamofire
import Moya

public typealias DefaultAuthService = BaseService<AuthAPI>

public protocol AuthService {
    func signIn(token: String) -> AnyPublisher<SignInEntity, Error>
}

extension DefaultAuthService: AuthService {
    public func signIn(token: String) -> AnyPublisher<SignInEntity, Error> {
        return requestObjectInCombine(.signIn(token: token))
    }
}
