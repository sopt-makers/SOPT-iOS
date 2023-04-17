//
//  AlamoInterceptor.swift
//  Network
//
//  Created by Junho Lee on 2023/04/17.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core

import Alamofire

public class AlamoInterceptor: RequestInterceptor {
    
    public typealias AdapterResult = Swift.Result<URLRequest, Error>
    private var userService = DefaultUserService()

    public func retry(_ request: Alamofire.Request, for session: Alamofire.Session, dueTo error: Swift.Error, completion: @escaping (RetryResult) -> Void) {
        // token 재발급 API가 아니며 && 로그인 실패가 아니며 && 토큰이 만료된 경우(401)
        guard let pathComponents = request.request?.url?.pathComponents,
              !pathComponents.contains("refresh"),
              !pathComponents.contains("playground"),
              let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        userService.reissuance { reissuanceSuccessed in
            if reissuanceSuccessed {
                print("토큰 갱신 성공: ", request.request?.url)
                completion(.retry)
            } else {
                print("토큰 갱신 실패: ", request.request?.url)
                completion(.doNotRetryWithError(error))
            }
        }
    }
}

