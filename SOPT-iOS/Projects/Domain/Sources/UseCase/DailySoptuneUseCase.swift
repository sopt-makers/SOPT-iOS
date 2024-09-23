//
//  DailySoptuneUseCase.swift
//  Domain
//
//  Created by Jae Hyun Lee on 9/23/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol DailySoptuneUseCase {
    var todaysFortuneCard: PassthroughSubject<DailySoptuneCardModel, Never> { get }
    
    func getTodaysFortuneCard()
}

public class DefaultDailySoptuneUseCase {
    
    public let repository: DailySoptuneRepositoyInterface
    public let cancelBag = CancelBag()
    
    public let todaysFortuneCard = PassthroughSubject<DailySoptuneCardModel, Never>()
    
    public init(repository: DailySoptuneRepositoyInterface) {
        self.repository = repository
    }
}

extension DefaultDailySoptuneUseCase: DailySoptuneUseCase {
    public func getTodaysFortuneCard() {
        repository.getTodaysFortuneCard()
            .sink { event in
                print("GetTodaysFortuneCard State: \(event)")
            } receiveValue: { [weak self] todaysFortuneCard in
                self?.todaysFortuneCard.send(todaysFortuneCard)
            }.store(in: cancelBag)
    }
}
