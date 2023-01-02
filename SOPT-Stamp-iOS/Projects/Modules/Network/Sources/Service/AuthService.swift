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
    func getEmailAvailable(email: String) -> AnyPublisher<Int, Error>
    func changePassword(password: String, userId: Int) -> AnyPublisher<Int, Error>
}

extension DefaultAuthService: AuthService {
    public func getNicknameAvailable(nickname: String) -> AnyPublisher<Int, Error> {
        return requestObjectInCombineNoResult(.getNicknameAvailable(nickname: nickname))
    }
    
    public func getEmailAvailable(email: String) -> AnyPublisher<Int, Error> {
        return requestObjectInCombineNoResult(.getEmailAvailable(email: email))
    }
    
    public func changePassword(password: String, userId: Int) -> AnyPublisher<Int, Error> {
        return requestObjectInCombineNoResult(.changePassword(password: password, userId: userId))
    }
}
