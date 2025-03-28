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
            .mapVoid()
            .mapError {
                PhoneVerifyError.unknown($0) //TODO: 기획 명세에 맞게 에러 매핑
            }
            .eraseToAnyPublisher()
    }
    
    public func verify(_ model: Domain.PhoneVerifyModel) -> AnyPublisher<Void, Domain.PhoneVerifyError> {
        coreAuthService.verifyCode(model.toData())
            .mapVoid()
            .mapError {
                PhoneVerifyError.unknown($0) //TODO: 기획 명세에 맞게 에러 매핑
            }
            .eraseToAnyPublisher()
    }
    
    
}


