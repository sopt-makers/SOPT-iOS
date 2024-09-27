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

public final class DailySoptuneRepository {
    
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

extension DailySoptuneRepository: DailySoptuneRepositoryInterface {
    
    public func getDailySoptuneResult(date: String) -> AnyPublisher<DailySoptuneResultModel, Error> {
        self.fortuneService
            .getDailySoptuneResult(date: date)
            .map{ $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func getTodaysFortuneCard() -> AnyPublisher<Domain.DailySoptuneCardModel, any Error> {
        fortuneService.getTodaysFortuneCard()
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func getRandomUser() -> AnyPublisher<[Domain.PokeRandomUserInfoModel], any Error> {
        pokeService.getRandomUsers(randomType: nil, size: 1)
            .map { $0.randomInfoList.map { $0.toDomain() }}
            .eraseToAnyPublisher()
    }
    
    public func poke(userId: Int, message: String, isAnonymous: Bool) -> AnyPublisher<Domain.PokeUserModel, Domain.PokeError> {
        pokeService.poke(userId: userId, message: message, isAnonymous: isAnonymous)
            .mapErrorToPokeError()
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
