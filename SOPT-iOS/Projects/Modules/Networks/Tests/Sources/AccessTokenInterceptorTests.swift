//
//  InterceptorTests.swift
//  NetworksTests
//
//  Created by 장석우 on 6/23/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Testing

@testable import Networks

@testable import Moya


struct AccessTokenInterceptorTests {

    @Test
    func HTTP헤더의_Authorization키가_존재한다면_token을_주입하는가() async throws {
        await confirmation { confirmation in
            let accessToken = "stub_accessToken"
            
            let sut = AccessTokenInterceptor(
                accessTokenClosure: { accessToken }
            )
            
            var urlRequest = URLRequest(url: URL(string: "http://")!)
            urlRequest.headers["Authorization"] = ""
            
            sut.adapt(
                urlRequest,
                for: Session(interceptor: sut)
            ) { result in
                switch result {
                case .success(let response):
                    #expect(response.headers["Authorization"] == accessToken)
                    confirmation()
                case .failure:
                    Issue.record("발생할 일 없음")
                }
            }
        }
    }
    
    /// 현재 Interceptor구조는 Authorization키가 없다면 token을 주입하지 않는 방식입니다.
    @Test
    func HTTP헤더에_Authorization키가_없다면_token을_주입하지않는가() async throws {
        await confirmation { confirmation in
            
            let sut = AccessTokenInterceptor(
                accessTokenClosure: { "stub_accessToken" }
            )
            
            let urlRequest = URLRequest(url: URL(string: "http://")!)
            // header = [:] 헤더에 Authorization 없을 때
            
            sut.adapt(
                urlRequest,
                for: Session(interceptor: sut)
            ) { result in
                switch result {
                case .success(let response):
                    #expect(response.headers["Authorization"] == nil)
                    confirmation()
                case .failure:
                    Issue.record("발생할 일 없음")
                }
            }
        }
    }

}

