//
//  DailySoptuneUseCase.swift
//  Domain
//
//  Created by Jae Hyun Lee on 9/23/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol DailySoptuneUseCase {
    var todaysFortuneCard: PassthroughSubject<DailySoptuneCardModel, Never> { get }
    var randomUser: PassthroughSubject<[PokeRandomUserInfoModel], Never> { get }
    var pokedResponse: PassthroughSubject<PokeUserModel, Never> { get }
    
    func getTodaysFortuneCard()
    func getRandomUser()
    func poke(userId: Int, message: PokeMessageModel, isAnonymous: Bool)
}

public class DefaultDailySoptuneUseCase {
    
    public let repository: DailySoptuneRepositoyInterface
    public let cancelBag = CancelBag()
    
    public let todaysFortuneCard = PassthroughSubject<DailySoptuneCardModel, Never>()
    public let randomUser = PassthroughSubject<[PokeRandomUserInfoModel], Never>()
    public let pokeMessages = PassthroughSubject<PokeMessagesModel, Never>()
    public let pokedResponse = PassthroughSubject<PokeUserModel, Never>()
    public let errorMessage = PassthroughSubject<String?, Never>()
    
    public init(repository: DailySoptuneRepositoyInterface) {
        self.repository = repository
    }
}

extension DefaultDailySoptuneUseCase: DailySoptuneUseCase {
    
    public func getTodaysFortuneCard() {
        repository.getTodaysFortuneCard()
            .withUnretained(self)
            .sink { event in
                print("GetTodaysFortuneCard State: \(event)")
            } receiveValue: { _, todaysFortuneCard in
                self.todaysFortuneCard.send(todaysFortuneCard)
            }.store(in: cancelBag)
    }
    
    public func getRandomUser() {
        repository.getRandomUser()
            .withUnretained(self)
            .sink { event in
                print("GetRandomUser State: \(event)")
            } receiveValue: { _, randomUser in
                self.randomUser.send(randomUser)
            }.store(in: cancelBag)
    }

    public func poke(userId: Int, message: PokeMessageModel, isAnonymous: Bool) {
        repository.poke(userId: userId, message: message.content, isAnonymous: isAnonymous)
            .catch { [weak self] error in
                let message = error.toastMessage
                self?.errorMessage.send(message)
                return Empty<PokeUserModel, Never>()
            }
            .withUnretained(self)
            .sink { _, user in
                self.pokedResponse.send(user)
            }
            .store(in: cancelBag)
    }
    
}
