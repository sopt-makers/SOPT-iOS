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
    
    private let attendanceService: AttendanceService
    private let cancelBag = CancelBag()
    
    public init(service: AttendanceService) {
        self.attendanceService = service
    }
}

extension ShowAttendanceRepository: ShowAttendanceRepositoryInterface {
    public func fetchAttendanceScheduleModel() -> AnyPublisher<AttendanceScheduleModel, Error> {
        return self.attendanceService.fetchAttendanceSchedule()
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func fetchAttendanceScoreModel() -> AnyPublisher<Domain.AttendanceScoreModel, Error> {
        return self.attendanceService.fetchAttendanceScore()
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
