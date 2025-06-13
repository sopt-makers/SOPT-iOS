//
//  PhoneVerifyRepository.swift
//  Data
//
//  Created by 장석우 on 1/23/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Combine

import Domain
import Networks

public struct PhoneVerifyRepository {
    
    private let coreAuthService: CoreAuthService
    
    public init(coreAuthService: CoreAuthService) {
        self.coreAuthService = coreAuthService
    }
}

extension PhoneVerifyRepository: PhoneVerifyRepositoryInterface {
    public func send(_ model: Domain.PhoneSendModel) -> AnyPublisher<Void, Domain.PhoneVerifyError> {
        coreAuthService.sendVerifyCode(model.toData())
            .mapError { moyaError in
                switch moyaError.response?.statusCode {
                case 400: return PhoneVerifyError.alreadyExist
                case 404: return PhoneVerifyError.userNotFound
                default: return PhoneVerifyError.unknown(moyaError)
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func verify(_ model: Domain.PhoneVerifyModel) -> AnyPublisher<Void, Domain.PhoneVerifyError> {
        coreAuthService.verifyCode(model.toData())
            .mapError { moyaError in
                switch moyaError.response?.statusCode {
                case 400: return PhoneVerifyError.invalidVerifyCode
                case 404: return PhoneVerifyError.invalidRequest
                default: return PhoneVerifyError.unknown(moyaError)
                }
            }
            .mapVoid()
            .eraseToAnyPublisher()
    }
    
    
}


