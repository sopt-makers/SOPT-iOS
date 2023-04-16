//
//  AppMyPageUseCase.swift
//  Domain
//
//  Created by Ian on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core

import Combine

public protocol AppMyPageUseCase {
    func resetStamp()
    
    var resetSuccess: PassthroughSubject<Bool, Error> { get }
}

public final class DefaultAppMyPageUseCase {
    private let repository: AppMyPageRepositoryInterface
    
    public let resetSuccess = PassthroughSubject<Bool, Error>()
    private let cancelBag = CancelBag()
    
    public init(repository: AppMyPageRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultAppMyPageUseCase: AppMyPageUseCase {
    public func resetStamp() {
        repository.resetStamp()
            .sink { success in
                self.resetSuccess.send(success)
            }.store(in: self.cancelBag)
    }
}
