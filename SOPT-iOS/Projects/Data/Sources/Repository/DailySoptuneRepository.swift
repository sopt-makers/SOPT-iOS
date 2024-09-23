//
//  DailySoptuneRepository.swift
//  Data
//
//  Created by Jae Hyun Lee on 9/23/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Networks

public class DailySoptuneRepository {
    
    private let fortuneService: FortuneService
    private let pokeService: PokeService
    
    private let cancelBag = CancelBag()
    
    public init(
        fortuneService: FortuneService,
        pokeService: PokeService
    ) {
        self.fortuneService = fortuneService
        self.pokeService = pokeService
    }
    
}

extension DailySoptuneRepository: DailySoptuneRepositoyInterface {
    public func getTodaysFortuneCard() -> AnyPublisher<Domain.DailySoptuneCardModel, any Error> {
        fortuneService.getTodaysFortuneCard()
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func getFriendRandomUser() -> AnyPublisher<Domain.PokeFriendRandomUserModel, any Error> {
        pokeService.getFriendRandomUser(randomType: "", size: 1)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
    
