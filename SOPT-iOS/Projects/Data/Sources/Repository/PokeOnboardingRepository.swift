//
//  PokeOnboardingRepository.swift
//  Data
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Networks

public final class PokeOnboardingRepository {
  private let pokeService: PokeService
  
  public init(pokeService: PokeService) {
    self.pokeService = pokeService
  }
}

extension PokeOnboardingRepository: PokeOnboardingRepositoryInterface {
  public func getRandomAcquaintances(
    randomUserType: PokeRandomUserType,
    size: Int
  ) -> AnyPublisher<[PokeRandomUserInfoModel], Error> {
    self.pokeService
      .getRandomUsers(randomType: randomUserType.rawValue, size: size)
      .map { $0.randomInfoList.map { $0.toDomain() } }
      .eraseToAnyPublisher()
  }
  
  public func getMesseageTemplates(type: PokeMessageType) -> AnyPublisher<PokeMessagesModel, Error> {
    self.pokeService
      .getPokeMessages(messageType: type.rawValue)
      .map { $0.toDomain() }
      .eraseToAnyPublisher()
  }
  
  public func poke(userId: Int, message: String, isAnonymous: Bool) -> AnyPublisher<PokeUserModel, PokeError> {
    self.pokeService
      .poke(userId: userId, message: message, isAnonymous: isAnonymous)
      .mapErrorToPokeError()
      .map { $0.toDomain() }
      .eraseToAnyPublisher()
  }
}
