//
//  AttendanceRepository.swift
//  Data
//
//  Created by 김영인 on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Network

public class AttendanceRepository {
    
    private let attendanceService: AttendanceService
    private let cancelBag = CancelBag()
    
    public init(service: AttendanceService) {
        self.attendanceService = service
    }
}

extension AttendanceRepository: AttendanceRepositoryInterface {

    public func fetchLectureRound(lectureId: Int) -> AnyPublisher<Int, Error> {
        return self.attendanceService
            .fetchAttendanceRound(lectureId: lectureId)
            .compactMap { $0.data?.round }
            .eraseToAnyPublisher()
    }
    
    public func postAttendance(lectureRoundId: Int, code: Int) -> AnyPublisher<Bool, Error> {
        return self.attendanceService
            .postAttendance(lectureRoundId: lectureRoundId, code: code)
            .map { $0.success }
            .eraseToAnyPublisher()
    }
}