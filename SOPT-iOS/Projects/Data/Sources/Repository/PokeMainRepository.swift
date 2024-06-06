//
//  PokeMainRepository.swift
//  Data
//
//  Created by sejin on 12/19/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Networks

public class PokeMainRepository {
    
    private let pokeService: PokeService
    private let cancelBag = CancelBag()
    
    public init(service: PokeService) {
        self.pokeService = service
    }
}

extension PokeMainRepository: PokeMainRepositoryInterface {
    public func getWhoPokeToMe() -> AnyPublisher<Domain.PokeUserModel?, Error> {
        pokeService.getWhoPokedToMe()
            .map { $0?.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func getFriend() -> AnyPublisher<[PokeUserModel], Error> {
        pokeService.getFriend()
            .map { $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
    
    public func getFriendRandomUser(randomType: String, size: Int) -> AnyPublisher<PokeFriendRandomUserModel, Error> {
        pokeService.getFriendRandomUser(randomType: randomType, size: size)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func poke(userId: Int, message: String, isAnonymous: Bool) -> AnyPublisher<Domain.PokeUserModel, PokeError> {
        self.pokeService
            .poke(userId: userId, message: message, isAnonymous: isAnonymous)
            .mapErrorToPokeError()
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func checkPokeNewUser() -> AnyPublisher<Bool, Error> {
        pokeService.isNewUser()
            .map { $0.isNew }
            .eraseToAnyPublisher()
    }
}
