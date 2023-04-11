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
    func getNicknameAvailable(nickname: String) -> AnyPublisher<Int, Error>
    func changeNickname(userId: Int, nickname: String) -> AnyPublisher<Int, Error>
    func withdrawal(userId: Int) -> AnyPublisher<Int, Error>
}

extension DefaultAuthService: AuthService {
    public func getNicknameAvailable(nickname: String) -> AnyPublisher<Int, Error> {
        return requestObjectInCombineNoResult(.getNicknameAvailable(nickname: nickname))
    }
    
    public func changeNickname(userId: Int, nickname: String) -> AnyPublisher<Int, Error> {
        return requestObjectInCombineNoResult(.changeNickname(userId: userId, nickname: nickname))
    }
    
    public func withdrawal(userId: Int) -> AnyPublisher<Int, Error> {
        return requestObjectInCombineNoResult(.withdrawal(userId: userId))
    }
}
