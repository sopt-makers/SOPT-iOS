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
    func getPokeMessageTemplates(type: PokeMessageType)
    
    var pokeMessageModels: PassthroughSubject<PokeMessagesModel, Never> { get }
}

public final class DefaultPokeMessageTemplateUsecase {
    private let repository: PokeOnboardingRepositoryInterface
    private let cancelBag = CancelBag()
    
    public let pokeMessageModels = PassthroughSubject<PokeMessagesModel, Never>()
    
    public init(repository: PokeOnboardingRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultPokeMessageTemplateUsecase: PokeMessageTemplateUsecase {
    public func getPokeMessageTemplates(type: PokeMessageType) {
        self.repository
            .getMesseageTemplates(type: type)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] value in
                    self?.pokeMessageModels.send(value)
                }
            ).store(in: self.cancelBag)
    }
}
