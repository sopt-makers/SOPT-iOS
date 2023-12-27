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
    public func getRandomAcquaintances() -> AnyPublisher<[PokeUserModel], Error> {
        self.pokeService
            .getRandomUsers()
            .map { $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
    
    public func getMesseageTemplates(type: PokeMessageType) -> AnyPublisher<PokeMessagesModel, Error> {
        self.pokeService
            .getPokeMessages(messageType: type.rawValue)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }

    public func poke(userId: Int, message: String) -> AnyPublisher<PokeUserModel, PokeError> {
        self.pokeService
            .poke(userId: userId, message: message)
            .mapErrorToPokeError()
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
