//
//  RankingRepository.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Network

public class RankingRepository {
    
    private let networkService: RankService
    private let cancelBag = CancelBag()
    
    public init(service: RankService) {
        self.networkService = service
    }
}

extension RankingRepository: RankingRepositoryInterface {
    
}
