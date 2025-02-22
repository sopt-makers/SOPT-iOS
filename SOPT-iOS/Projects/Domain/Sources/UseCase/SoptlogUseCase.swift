//
//  SoptlogUseCase.swift
//  Domain
//
//  Created by 강윤서 on 1/19/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Networks

public protocol SoptlogUseCase {
    func fetchSoptlogInfo() -> AnyPublisher<SoptlogModel, MainError>
}

public class DefaultSoptlogUseCase: SoptlogUseCase {
    
    private let repository: SoptlogRepositoryInterface
    private let cancelBag = CancelBag()
    
    public init(repository: SoptlogRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultSoptlogUseCase {
    public func fetchSoptlogInfo() -> AnyPublisher<SoptlogModel, MainError> {
        self.repository.fetchSoptlogModel()
            .eraseToAnyPublisher()
    }
}
