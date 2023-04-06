//
//  MainRepository.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Domain
import Network

public class MainRepository {
    
    private let networkService: UserService
    private let cancelBag = Set<AnyCancellable>()
    
    public init(service: UserService) {
        self.networkService = service
    }
}

extension MainRepository: MainRepositoryInterface {
    
}
