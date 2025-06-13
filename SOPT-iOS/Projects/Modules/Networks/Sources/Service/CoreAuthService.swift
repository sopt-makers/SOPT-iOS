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
import CombineMoya


public typealias DefaultCoreAuthService = BaseService<CoreAuthAPI>

public protocol CoreAuthService {
    func sendVerifyCode(_ dto: SendVerificationCodeRequestEntity) -> AnyPublisher<Void, MoyaError>
    func verifyCode(_ dto: VerifyCodeRequestEntity) -> AnyPublisher<VerifyResultEntity, MoyaError>
    func login(_ dto: CoreLoginRequestEntity) -> AnyPublisher<BaseEntity<CoreLoginEntity>, Error>
    func signUp(_ dto: CoreSignUpRequestEntity) -> AnyPublisher<Int, Error>
}

extension DefaultCoreAuthService: CoreAuthService {
    
    public func sendVerifyCode(_ dto: SendVerificationCodeRequestEntity) -> AnyPublisher<Void, MoyaError> {
        provider.requestPublisher(.sendVerifyCode(dto: dto))
            .filterSuccessfulStatusCodes()
            .mapVoid()
    }
    
    public func verifyCode(_ dto: VerifyCodeRequestEntity) -> AnyPublisher<VerifyResultEntity, MoyaError> {
        provider.requestPublisher(.verfiyCode(dto: dto))
            .filterSuccessfulStatusCodes()
            .map(BaseEntity<VerifyResultEntity>.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    public func login(_ dto: CoreLoginRequestEntity) -> AnyPublisher<BaseEntity<CoreLoginEntity>, Error> {
        requestObjectInCombine(.login(dto: dto))
    }
    
    public func signUp(_ dto: CoreSignUpRequestEntity) -> AnyPublisher<Int, Error> {
        requestObjectInCombineNoResult(.signUp(dto: dto))
    }
    
}

