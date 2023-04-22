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
                     .compactMap { $0.data?.toDomain() }
                     .eraseToAnyPublisher()
    }
    
    public func fetchAttendanceScoreModel() -> AnyPublisher<Domain.AttendanceScoreModel, Error> {
        return self.attendanceService.fetchAttendanceScore()
                     .compactMap{ $0.data?.toDomain() }
                     .eraseToAnyPublisher()
    }
    
    public func fetchLectureRound(lectureId: Int) -> AnyPublisher<AttendanceRoundModel?, Error> {
        return self.attendanceService
            .fetchAttendanceRound(lectureId: lectureId)
            .compactMap { $0.data?.toDomain() }
            .eraseToAnyPublisher()
    }
}
