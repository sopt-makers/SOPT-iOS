//
//  HomeRepository.swift
//  Data
//
//  Created by Jae Hyun Lee on 1/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Networks

public class HomeRepository {
    
    private let homeService: HomeService
    
    private let cancelBag = CancelBag()
    
    public init(homeService: HomeService) {
        self.homeService = homeService
    }
}

extension HomeRepository: HomeRepositoryInterface {

}
