//
//  PokeOnboardingRepositoryInterface.swift
//  Domain
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

public protocol PokeOnboardingRepositoryInterface: PokeRepositoryInterface {
  func getRandomAcquaintances(
    randomUserType: PokeRandomUserType,
    size: Int
  ) -> AnyPublisher<[PokeRandomUserInfoModel], Error>
  func getMesseageTemplates(type: PokeMessageType) -> AnyPublisher<PokeMessagesModel, Error>
}


