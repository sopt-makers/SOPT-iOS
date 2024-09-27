//
//  DailySoptuneUseCase.swift
//  Domain
//
//  Created by 강윤서 on 9/27/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol DailySoptuneUseCase {
    var dailySoptuneResult: PassthroughSubject<DailySoptuneResultModel, Never> { get }
    
    func getDailySoptuneResult(date: String)
}


public class DefaultDailySoptuneUseCase {
    
    private let repository: DailySoptuneRepositoryInterface
    private let cancelBag = CancelBag()
    
    public let dailySoptuneResult = PassthroughSubject<DailySoptuneResultModel, Never>()
    
    public init(repository: DailySoptuneRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultDailySoptuneUseCase: DailySoptuneUseCase {
    public func getDailySoptuneResult(date: String) {
        repository.getDailySoptuneResult(date: date)
            .withUnretained(self)
            .sink { event in
                print("GetDailySoptuneResult State: \(event)")
            } receiveValue: { _, resultModel in
                self.dailySoptuneResult.send(resultModel)
            }
            .store(in: cancelBag)
    }
}
