//
//  SoptlogUseCase.swift
//  Domain
//
//  Created by 강윤서 on 1/19/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol SoptlogUseCase {
    func fetchSoptlogInfo() -> AnyPublisher<SoptlogModel, Never>
}

public class DefaultSoptlogUseCase: SoptlogUseCase {
    
    private let repository: SoptlogRepositoryInterface
    private let cancelBag = CancelBag()
    
    public init(repository: SoptlogRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultSoptlogUseCase {
    public func fetchSoptlogInfo() -> AnyPublisher<SoptlogModel, Never> {
        self.repository.fetchSoptlogModel()
            .catch { error in
                print("Error: \(error)")
                return Empty<SoptlogModel, Never>()
            }
            .eraseToAnyPublisher()
    }
}
