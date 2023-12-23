//
//  PokeMessageTemplateUsecase.swift
//  Domain
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol PokeMessageTemplateUsecase {
    func getPokeMessageTemplates()
    
    var pokeMessageModels: PassthroughSubject<[PokeMessageModel], Never> { get }
}

public final class DefaultPokeMessageTemplateUsecase {
    private let repository: PokeOnboardingRepositoryInterface
    private let cancelBag = CancelBag()
    
    public let pokeMessageModels = PassthroughSubject<[PokeMessageModel], Never>()
    
    public init(repository: PokeOnboardingRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultPokeMessageTemplateUsecase: PokeMessageTemplateUsecase {
    public func getPokeMessageTemplates() {
        self.repository
            .getMesseageTemplates()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] value in
                    self?.pokeMessageModels.send(value)
                }
            ).store(in: self.cancelBag)
    }
}
