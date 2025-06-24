//
//  AlamoInterceptor.swift
//  Network
//
//  Created by Junho Lee on 2023/04/17.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

import Alamofire

public final class ReissuanceInterceptor: RequestInterceptor {
    
    public typealias AccessTokenClosure = (@Sendable () -> String)
    
    public typealias ReissueClosure = (@Sendable (@escaping (Bool) -> Void) -> Void)
    
    private let accessTokenClosure: AccessTokenClosure
    
    private let reissuance: ReissueClosure
    
    public init(
        accessTokenClosure: @escaping AccessTokenClosure,
        reissuance: @escaping ReissueClosure
    ) {
        self.accessTokenClosure = accessTokenClosure
        self.reissuance = reissuance
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
    }
    
    public func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult
        ) -> Void) {
        guard error.asAFError?.responseCode == 401
        else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        reissuance() { reissuanceSuccessed in
            if reissuanceSuccessed {
                completion(.retry)
            } else {
                completion(.doNotRetryWithError(APIError.tokenReissuanceFailed))
            }
        }
    }
}
