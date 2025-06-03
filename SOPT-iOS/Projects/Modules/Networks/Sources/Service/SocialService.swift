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
    func getSocialAccount(for phoneNumber: String) -> AnyPublisher<BaseEntity<SocialAccountResultEntity>, Error>
    func changeSocialAccount(_ dto: CoreSignUpRequestEntity) -> AnyPublisher<Int, Error>
}

extension DefaultSocialService: SocialService {
    public func getSocialAccount(for phoneNumber: String) -> AnyPublisher<BaseEntity<SocialAccountResultEntity>, Error> {
        requestObjectInCombine(.getSocialAccount(phone: phoneNumber))
    }
    
    public func changeSocialAccount(_ dto: CoreSignUpRequestEntity) -> AnyPublisher<Int, Error> {
        return requestObjectInCombineNoResult(.changeSocialAccount(dto: dto))
    }
}
