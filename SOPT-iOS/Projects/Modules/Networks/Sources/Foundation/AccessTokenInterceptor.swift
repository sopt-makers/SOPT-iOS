//
//  AuthInterceptor.swift
//  Networks
//
//  Created by 장석우 on 6/21/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

import Alamofire


public class AccessTokenInterceptor: RequestInterceptor {
    
    public typealias AccessTokenClosure = (@Sendable () -> String)
    
    private let accessTokenClosure: AccessTokenClosure
    
    public init(
        accessTokenClosure: @escaping AccessTokenClosure = { UserDefaultKeyList.Auth.appAccessToken ?? ""}
    ) {
        self.accessTokenClosure = accessTokenClosure
    }
    
    public func adapt(_ urlRequest: URLRequest, for session: Alamofire.Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var adaptedRequest = urlRequest
        validateHeader(&adaptedRequest)
        completion(.success(adaptedRequest))
    }
    
    private func validateHeader(_ urlRequest: inout URLRequest) {
        let headers = urlRequest.headers.map {
            guard $0.name == "Authorization" else {
                return $0
            }
            return HTTPHeader(name: $0.name, value: accessTokenClosure())
        }
        urlRequest.headers = HTTPHeaders(headers)
    }
}
