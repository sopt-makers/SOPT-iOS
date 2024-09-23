//
//  DailySoptuneRepository.swift
//  Data
//
//  Created by Jae Hyun Lee on 9/23/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Networks

public class DailySoptuneRepository {
    
    private let fortuneService: FortuneService
    private let cancelBag = CancelBag()
    
    public init(service: FortuneService) {
        self.fortuneService = service
    }
    
}

extension DailySoptuneRepository: DailySoptuneRepositoryInterface {
    
}
