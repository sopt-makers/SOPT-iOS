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


public final class AccessTokenInterceptor: RequestInterceptor {
    
    public typealias AccessTokenClosure = (() -> String?)
    
    public var accessTokenClosure: AccessTokenClosure?
    
    public init(
        accessTokenClosure: AccessTokenClosure? = nil
    ) {
        self.accessTokenClosure = accessTokenClosure
    }
    
    public func adapt(_ urlRequest: URLRequest, for session: Alamofire.Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var adaptedRequest = urlRequest
        adaptedRequest.headers["Authorization"] = accessTokenClosure?() ?? ""
        completion(.success(adaptedRequest))
    }
    
    public func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        completion(.doNotRetry)
    }
}
