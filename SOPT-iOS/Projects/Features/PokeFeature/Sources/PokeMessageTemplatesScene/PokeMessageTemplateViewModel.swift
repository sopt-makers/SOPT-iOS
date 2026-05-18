//
//  PokeMessageTemplateViewModel.swift
//  PokeFeatureInterface
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain

import PokeFeatureInterface

public final class PokeMessageTemplateViewModel: PokeMessageTemplatesViewModelType {
    
    public var messageType: PokeMessageType
    
    private let messageTemplateConfig: PokeMessageTemplateConfig
    
    public struct Input {
        let viewDidLoaded: Driver<Void>
    }
    
    public struct Output {
        let messageTemplates = PassthroughSubject<PokeMessagesModel, Never>()
        let messageTemplateConfig = PassthroughSubject<PokeMessageTemplateConfig, Never>()
    }
    
    private let usecase: PokeMessageTemplateUsecase
    
    public init(messageType: PokeMessageType, usecase: PokeMessageTemplateUsecase, config: PokeMessageTemplateConfig) {
        self.messageType = messageType
        self.usecase = usecase
        self.messageTemplateConfig = config
    }
}

extension PokeMessageTemplateViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
            
        input.viewDidLoaded
            .withUnretained(self)
            .sink(receiveValue: { owner, _ in
                owner.usecase.getPokeMessageTemplates(type: owner.messageType)
                output.messageTemplateConfig.send(owner.messageTemplateConfig)
            }).store(in: cancelBag)
        
        return output
    }
}

extension PokeMessageTemplateViewModel {
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        self.usecase
            .pokeMessageModels
            .asDriver()
            .sink(receiveValue: { values in
                output.messageTemplates.send(values)
            }).store(in: cancelBag)
    }
}
