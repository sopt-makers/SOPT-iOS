//
//  SignUpRepository.swift
//  Data
//
//  Created by sejin on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Domain
import Network

public class SignUpRepository {
    
    private let networkService: AuthService
    private let cancelBag = Set<AnyCancellable>()
    
    public init(service: AuthService) {
        self.networkService = service
    }
}

extension SignUpRepository: SignUpRepositoryInterface {
    
}
