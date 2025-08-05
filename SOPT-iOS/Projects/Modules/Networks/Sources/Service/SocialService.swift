//
//  SocialService.swift
//  Networks
//
//  Created by 장석우 on 12/28/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Moya


public typealias DefaultSocialService = BaseService<SocialAPI>

public protocol SocialService {
    func getSocialAccount(for phoneNumber: String) -> AnyPublisher<SocialAccountResultEntity, MoyaError>
    func changeSocialAccount(_ dto: CoreSignUpRequestEntity) -> AnyPublisher<Void, MoyaError>
}

extension DefaultSocialService: SocialService {
    public func getSocialAccount(for phoneNumber: String) -> AnyPublisher<SocialAccountResultEntity, MoyaError> {
        provider.requestPublisher(.getSocialAccount(phone: phoneNumber))
            .filterSuccessfulStatusCodes()
            .map(BaseEntity<SocialAccountResultEntity>.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    public func changeSocialAccount(_ dto: CoreSignUpRequestEntity) -> AnyPublisher<Void, MoyaError> {
        provider.requestPublisher(.changeSocialAccount(dto: dto))
            .filterSuccessfulStatusCodes()
            .mapVoid()
            .eraseToAnyPublisher()
    }
}
