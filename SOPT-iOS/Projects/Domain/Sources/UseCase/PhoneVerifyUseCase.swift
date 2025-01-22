//
//  PhoneVerifyUseCase.swift
//  Domain
//
//  Created by 장석우 on 12/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public struct PhoneVerifyPolicy {
    public let phoneMaxLength: Int
    public let codeMaxLength: Int
    private let _timeLimit: Duration
    public var timeLimit: Int { Int(_timeLimit.components.seconds) }
    
    public init(phoneMaxLength: Int, codeMaxLength: Int, timeLimit: Duration) {
        self.phoneMaxLength = phoneMaxLength
        self.codeMaxLength = codeMaxLength
        self._timeLimit = timeLimit
    }
}

extension PhoneVerifyPolicy {
    static let `default` = Self(phoneMaxLength: 11, codeMaxLength: 6, timeLimit: .seconds(180))
    static let stub = Self(phoneMaxLength: 11, codeMaxLength: 6, timeLimit: .seconds(10))
}

public protocol PhoneVerifyUseCase {
    var policy: PhoneVerifyPolicy { get }
    
    var sideEffect: PassthroughSubject<PhoneVerifyError, Never> { get }
    
    func send(_ model: PhoneSendModel) -> AnyPublisher<Void, Never>
    func verify(_ model: PhoneVerifyModel) -> AnyPublisher<Void, Never>
}


public struct DefaultPhoneVerifyUseCase: PhoneVerifyUseCase {
    
    private let repository: PhoneVerifyRepositoryInterface
    
    public let policy: PhoneVerifyPolicy = .default
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

public class StubPhoneVerifyUseCase: PhoneVerifyUseCase {
    
    public init() { }
    
    public let policy: PhoneVerifyPolicy = .stub
    public var sideEffect = PassthroughSubject<PhoneVerifyError, Never>()
    
    public func send(_ model: PhoneSendModel) -> AnyPublisher<Void, Never> {
        return Just(()).eraseToAnyPublisher()
    }
    
    public func verify(_ model: PhoneVerifyModel) -> AnyPublisher<Void, Never> {
        sideEffect.send(.userNotFound)
        return Empty().eraseToAnyPublisher()
    }
}
