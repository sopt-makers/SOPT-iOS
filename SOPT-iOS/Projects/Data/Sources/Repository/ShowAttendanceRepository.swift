//
//  ShowAttendanceRepository.swift
//  Data
//
//  Created by devxsby on 2023/04/11.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core

import Domain
import Network

public class ShowAttendanceRepository {
    
    private let networkService: AttendanceService
    private let cancelBag = CancelBag()
    
    public init(service: AttendanceService) {
        self.networkService = service
    }
}

extension ShowAttendanceRepository: ShowAttendanceRepositoryInterface {
    
}
