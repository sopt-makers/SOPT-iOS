//
//  SettingRepository.swift
//  Presentation
//
//  Created by 양수빈 on 2022/12/17.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Network

public class SettingRepository {
    
    private let networkService: UserService
    private let cancelBag = CancelBag()
    
    public init(service: UserService) {
        self.networkService = service
    }
}

extension SettingRepository: SettingRepositoryInterface {
    
}
