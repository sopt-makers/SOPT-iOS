//
//  PokeNotificationRepository.swift
//  Data
//
//  Created by Ian on 12/23/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Networks

public final class PokeNotificationRepository {
  private let pokeService: PokeService
  
  public init(pokeService: PokeService) {
    self.pokeService = pokeService
  }
}

extension PokeNotificationRepository: PokeNotificationRepositoryInterface {
  public func getWhoPokedMeList(page: Int) -> AnyPublisher<(users: [PokeUserModel], page: Int), Error> {
    self.pokeService
      .getWhoPokedToMeList(pageIndex: String(describing: page))
      .map { (users: $0.history.map { $0.toDomain() }, page: $0.pageNum) }
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
