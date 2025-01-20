//
//  SoptlogRepository.swift
//  Data
//
//  Created by 강윤서 on 1/19/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core
import Domain
import Networks

public class SoptlogRepository {
    
    private let homeService: HomeService
    
    private let cancelBag = CancelBag()
    
    public init(homeService: HomeService) {
        self.homeService = homeService
    }
}

extension SoptlogRepository: SoptlogRepositoryInterface {
    
}
