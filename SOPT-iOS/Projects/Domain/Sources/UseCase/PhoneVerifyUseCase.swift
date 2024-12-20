//
//  PhoneVerifyUseCase.swift
//  Domain
//
//  Created by 장석우 on 12/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol PhoneVerifyUseCase {
    var sideEffect: PassthroughSubject<PhoneVerifyError, Never> { get }
    
    func send(_ model: PhoneSendModel) -> AnyPublisher<Void, Never>
    func verify(_ model: PhoneVerifyModel) -> AnyPublisher<Void, Never>
}


public struct DefaultPhoneVerifyUseCase: PhoneVerifyUseCase {
    
    private let repository: PhoneVerifyRepositoryInterface
    public let sideEffect = PassthroughSubject<PhoneVerifyError, Never>()
    
    init(repository: PhoneVerifyRepositoryInterface) {
        self.repository = repository
    }
    
    public func send(_ model: PhoneSendModel) -> AnyPublisher<Void, Never> {
        return repository.send(model)
            .catch {
                sideEffect.send($0)
                return Empty<Void, Never>()
            }.eraseToAnyPublisher()
    }
    
    public func verify(_ model: PhoneVerifyModel) -> AnyPublisher<Void, Never> {
        return repository.verify(model)
            .catch { 
                sideEffect.send($0)
                return Empty<Void, Never>()
            }.eraseToAnyPublisher()
    }
    
    
}

public struct StubPhoneVerifyUseCase: PhoneVerifyUseCase {
    public var sideEffect = PassthroughSubject<PhoneVerifyError, Never>()
    
    public func send(_ model: PhoneSendModel) -> AnyPublisher<Void, Never> {
        return Just(()).eraseToAnyPublisher()
    }
    
    public func verify(_ model: PhoneVerifyModel) -> AnyPublisher<Void, Never> {
        return Just(()).eraseToAnyPublisher()
    }
}
