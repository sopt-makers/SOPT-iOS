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
        return Future<AttendanceScheduleModel, Error> { promise in
            promise(.success(AttendanceScheduleModel(type: "HAS_ATTENDANCE",
                                                     location: "단국대학교 혜당관",
                                                     name: "3차 세미나",
                                                     startDate: "2023-04-06T14:13:51", endDate: "2023-04-06T18:13:51", message: "",
                                                     attendances: [TodayAttendanceModel(status: "ATTENDANCE", attendedAt: "2023-04-13T14:12:09"),
                                                                   TodayAttendanceModel(status: "ABSENT", attendedAt: "2023-04-13T14:10:04")])))
        }
        .eraseToAnyPublisher()
//        return self.attendanceService.fetchAttendanceSchedule()
//            .map { $0.toDomain() }
//            .eraseToAnyPublisher()
    }
    
    public func fetchAttendanceScoreModel() -> AnyPublisher<Domain.AttendanceScoreModel, Error> {
        return Future<AttendanceScoreModel, Error> { promise in
            promise(.success(AttendanceScoreModel.init(part: "iOS",
                                                       generation: 31,
                                                       name: "윤수빈",
                                                       score: 2.0,
                                                       total: TotalScoreModel(attendance: 2, absent: 0, tardy: 1, participate: 1),
                                                       attendances: [AttendanceModel(attribute: "ETC", name: "솝커톤", status: "TARDY", date: "4월 22일"),
                                                                     AttendanceModel(attribute: "SEMINAR", name: "iOS 2차 세미나", status: "ATTENDANCE", date: "4월 15일"),
                                                                     AttendanceModel(attribute: "SEMINAR", name: "iOS 1차 세미나", status: "ATTENDANCE", date: "4월 8일"),
                                                                     AttendanceModel(attribute: "ETC", name: "OT", status: "PARTICIPATE", date: "4월 1일")])))
        }.eraseToAnyPublisher()
//        return self.attendanceService.fetchAttendanceScore()
//            .map { $0.toDomain() }
//            .eraseToAnyPublisher()
    }
}
