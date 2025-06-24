//
//  ReissuanceInterceptorTests.swift
//  NetworksTests
//
//  Created by 장석우 on 6/24/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Testing

@testable import Networks

@testable import Moya
@testable import Alamofire


struct ReissuanceInterceptorTests {
    
    @Test
    func statusCode가_401일때_reissuance에_성공하면_기존API를_retry한다() async throws {
        await confirmation { confirmation in
            // Given
            let afError = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 401))
            let reissunance: ReissuanceInterceptor.ReissueClosure = { $0(true) }
            
            let sut = ReissuanceInterceptor(
                accessTokenClosure: { "" },
                reissuance: reissunance
            )

            let session = Session(interceptor: sut)
            let request = Alamofire.Request(
                underlyingQueue: .main,
                serializationQueue: .main,
                eventMonitor: nil,
                interceptor: sut,
                delegate: session
            )
            
            // When
            session.retryResult(
                for: request,
                dueTo: afError
            ) { retryResult in
                // Then
                switch retryResult {
                case .retry, .retryWithDelay:
                    confirmation()
                case .doNotRetry, .doNotRetryWithError:
                    Issue.record()
                }
            }
        }
    }
}

