//
//  PokeOnboardingUsecase.swift
//  Domain
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol PokeOnboardingUsecase {
    func getRandomAcquaintances()
    func poke(userId: Int, message: PokeMessageModel)
    
    var randomAcquaintances: PassthroughSubject<[PokeUserModel], Never> { get }
    var pokedResponse: PassthroughSubject<PokeUserModel, Never> { get }
    var errorMessage: PassthroughSubject<String?, Never> { get }
}

public final class DefaultPokeOnboardingUsecase {
    private let repository: PokeOnboardingRepositoryInterface
    private let cancelBag = CancelBag()
    
    public let randomAcquaintances = PassthroughSubject<[PokeUserModel], Never>()
    public let pokedResponse = PassthroughSubject<PokeUserModel, Never>()
    public let errorMessage = PassthroughSubject<String?, Never>()
    
    public init(repository: PokeOnboardingRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultPokeOnboardingUsecase: PokeOnboardingUsecase {
    public func getRandomAcquaintances() {
        self.repository
            .getRandomAcquaintances()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] value in
                    self?.randomAcquaintances.send(value)
                }
            ).store(in: self.cancelBag)
    }
    
    public func poke(userId: Int, message: PokeMessageModel) {
        self.repository
            .poke(userId: userId, message: message.content)
            .catch { [weak self] error in
                let message = error.toastMessage
                self?.errorMessage.send(message)
                return Empty<PokeUserModel, Never>()
            }
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] value in
                    self?.pokedResponse.send(value)
                }
            ).store(in: self.cancelBag)
    }
}

