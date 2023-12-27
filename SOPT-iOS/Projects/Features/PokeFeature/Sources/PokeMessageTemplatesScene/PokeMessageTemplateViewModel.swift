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
    
    public struct Input {
        let viewDidLoaded: Driver<Void>
    }
    
    public struct Output {
        let messageTemplates = PassthroughSubject<PokeMessagesModel, Never>()
    }
    
    private let usecase: PokeMessageTemplateUsecase
    
    public init(messageType: PokeMessageType, usecase: PokeMessageTemplateUsecase) {
        self.messageType = messageType
        self.usecase = usecase
    }
}

extension PokeMessageTemplateViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
            
        input.viewDidLoaded
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.usecase.getPokeMessageTemplates(type: self.messageType)
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
