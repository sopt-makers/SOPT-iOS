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
}
