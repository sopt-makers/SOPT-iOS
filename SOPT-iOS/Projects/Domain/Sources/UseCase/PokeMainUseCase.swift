//
//  PokeMainUseCase.swift
//  Domain
//
//  Created by sejin on 12/19/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol PokeMainUseCase {
    var pokedToMeUser: PassthroughSubject<PokeUserModel?, Never> { get }
    
    func getWhoPokedToMe()
}

public class DefaultPokeMainUseCase {
    public let repository: PokeMainRepositoryInterface
    public let cancelBag = CancelBag()
    
    public let pokedToMeUser = PassthroughSubject<PokeUserModel?, Never>()

    public init(repository: PokeMainRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultPokeMainUseCase: PokeMainUseCase {
    public func getWhoPokedToMe() {
        repository.getWhoPokeToMe()
            .catch { _ in
                Just<PokeUserModel?>(nil)
            }
            .sink { event in
                print("GetPokedToMe State: \(event)")
            } receiveValue: { [weak self] pokeUser in
                self?.pokedToMeUser.send(pokeUser)
            }.store(in: cancelBag)
    }
}
