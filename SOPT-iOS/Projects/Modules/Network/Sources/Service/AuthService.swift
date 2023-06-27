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
import Core

public typealias DefaultAuthService = BaseService<AuthAPI>

public protocol AuthService {
    func signIn(token: String, pushToken: String) -> AnyPublisher<SignInEntity, Error>
    func reissuance(completion: @escaping ((Bool) -> Void))
    func reissuance() -> AnyPublisher<SignInEntity, Error>
}

extension DefaultAuthService: AuthService {
    public func signIn(token: String, pushToken: String) -> AnyPublisher<SignInEntity, Error> {
        return requestObjectWithNetworkErrorInCombine(.signIn(token: token, pushToken: pushToken))
    }
    
    public func reissuance(completion: @escaping ((Bool) -> Void)) {
        provider.request(.reissuance) { response in
            switch response {
            case .success(let value):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(SignInEntity.self, from: value.data)
                    UserDefaultKeyList.Auth.appAccessToken = body.accessToken
                    UserDefaultKeyList.Auth.appRefreshToken = body.refreshToken
                    UserDefaultKeyList.Auth.playgroundToken = body.playgroundToken
                    UserDefaultKeyList.Auth.isActiveUser = body.status == .active
                    ? true
                    : false
                    completion(true)
                } catch {
                    completion(false)
                }
            case .failure:
                completion(false)
            }
        }
    }
    
    public func reissuance() -> AnyPublisher<SignInEntity, Error> {
        requestObjectInCombine(.reissuance)
    }
}
