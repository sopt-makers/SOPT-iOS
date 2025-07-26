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

public final class ReissueInterceptor: RequestInterceptor {
    
    public typealias AccessTokenClosure = (@Sendable () -> String?)
    
    public typealias RefreshClosure = (@Sendable (@escaping (Result<Void, ReissueError>) -> Void) -> Void)
    
    private let accessTokenClosure: AccessTokenClosure
    
    private let refreshClosure: RefreshClosure
    
    public init(
        accessTokenClosure: @escaping AccessTokenClosure,
        refreshClosure: @escaping RefreshClosure
    ) {
        self.accessTokenClosure = accessTokenClosure
        self.refreshClosure = refreshClosure
    }
    
    public func adapt(_ urlRequest: URLRequest, for session: Alamofire.Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var adaptedRequest = urlRequest
        adaptedRequest.headers["Authorization"] = accessTokenClosure()
        completion(.success(adaptedRequest))
    }
    
    public func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard error.asAFError?.responseCode == 401
        else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        refreshClosure() { result in
            switch result {
            case .success:
                completion(.retry)
            case .failure:
                completion(.doNotRetryWithError(APIError.tokenReissuanceFailed))
            }
        }
    }
}
