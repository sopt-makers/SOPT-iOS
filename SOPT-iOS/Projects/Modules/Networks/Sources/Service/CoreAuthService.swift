//
//  CoreAuthService.swift
//  Networks
//
//  Created by 장석우 on 12/30/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Moya
import Core

public typealias DefaultCoreAuthService = BaseService<CoreAuthAPI>

public protocol CoreAuthService {
    func sendVerifyCode(_ dto: SendVerificationCodeEntity) -> AnyPublisher<Int, Error>
    func verifyCode(_ dto: VerifyCodeEntity) -> AnyPublisher<BaseEntity<VerifyResultEntity>, Error>
}

extension DefaultCoreAuthService: CoreAuthService {
    public func sendVerifyCode(_ dto: SendVerificationCodeEntity) -> AnyPublisher<Int, Error> {
        requestObjectInCombineNoResult(.sendVerifyCode(dto: dto))
    }
    
    public func verifyCode(_ dto: VerifyCodeEntity) -> AnyPublisher<BaseEntity<VerifyResultEntity>, Error> {
        requestObjectInCombine(.verfiyCode(dto: dto))
    }
}

