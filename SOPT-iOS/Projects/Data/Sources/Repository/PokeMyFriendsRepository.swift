//
//  PokeMyFriendsRepository.swift
//  Data
//
//  Created by sejin on 12/21/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Networks

public class PokeMyFriendsRepository {
    
    private let pokeService: PokeService
    private let cancelBag = CancelBag()
    
    public init(service: PokeService) {
        self.pokeService = service
    }
}

extension PokeMyFriendsRepository: PokeMyFriendsRepositoryInterface {
    public func getFriends() -> AnyPublisher<Domain.PokeMyFriendsModel, Error> {
        pokeService.getFriendList()
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func getFriends(relation: String, page: Int) -> AnyPublisher<Domain.PokeMyFriendsListModel, Error> {
        pokeService.getFriendList(relation: relation, page: page)
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
}

