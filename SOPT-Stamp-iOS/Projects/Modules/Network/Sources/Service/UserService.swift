//
//  UserService.swift
//  Network
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

import Alamofire
import Domain
import Moya

public typealias DefaultUserService = BaseService<UserAPI>

public protocol UserService {
    func postSignUp(nickname: String, email: String, password: String) -> AnyPublisher<Int, Error>
}

extension DefaultUserService: UserService {
    public func postSignUp(nickname: String, email: String, password: String) -> AnyPublisher<Int, Error> {
        requestObjectInCombineNoResult(.signUp(nickname: nickname,
                                               email: email,
                                               password: password)
        )
    }
}
