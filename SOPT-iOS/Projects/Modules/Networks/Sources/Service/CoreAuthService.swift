//
//  CoreAuthService.swift
//  Networks
//
//  Created by 장석우 on 12/30/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Moya


public typealias DefaultCoreAuthService = BaseService<CoreAuthAPI>

public protocol CoreAuthService {
    func sendVerifyCode(_ dto: SendVerificationCodeRequestEntity) -> AnyPublisher<Int, Error>
    func verifyCode(_ dto: VerifyCodeRequestEntity) -> AnyPublisher<BaseEntity<VerifyResultEntity>, Error>
    func login(_ dto: CoreLoginRequestEntity) -> AnyPublisher<BaseEntity<CoreLoginEntity>, Error>
    func signUp(_ dto: CoreSignUpRequestEntity) -> AnyPublisher<Int, Error>
}

extension DefaultCoreAuthService: CoreAuthService {
    public func sendVerifyCode(_ dto: SendVerificationCodeRequestEntity) -> AnyPublisher<Int, Error> {
        requestObjectInCombineNoResult(.sendVerifyCode(dto: dto))
    }
    
    public func verifyCode(_ dto: VerifyCodeRequestEntity) -> AnyPublisher<BaseEntity<VerifyResultEntity>, Error> {
        requestObjectInCombine(.verfiyCode(dto: dto))
    }
    
    public func login(_ dto: CoreLoginRequestEntity) -> AnyPublisher<BaseEntity<CoreLoginEntity>, Error> {
        requestObjectInCombine(.login(dto: dto))
    }
    
    public func signUp(_ dto: CoreSignUpRequestEntity) -> AnyPublisher<Int, Error> {
        requestObjectInCombineNoResult(.signUp(dto: dto))
    }
}

