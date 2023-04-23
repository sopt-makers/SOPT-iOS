//
//  AttendanceService.swift
//  Network
//
//  Created by devxsby on 2023/04/11.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Alamofire
import Moya

public typealias DefaultAttendanceService = BaseService<AttendanceAPI>

public protocol AttendanceService {
    func fetchAttendanceSchedule() -> AnyPublisher<BaseEntity<AttendanceScheduleEntity>, Error>
    func fetchAttendanceScore() -> AnyPublisher<BaseEntity<AttendanceScoreEntity>, Error>
    func fetchAttendanceRound(lectureId: Int) -> AnyPublisher<BaseEntity<AttendanceRoundEntity>, Error>
    func postAttendance(lectureRoundId: Int, code: String) -> AnyPublisher<BaseEntity<String>, Error>
}

extension DefaultAttendanceService: AttendanceService {
    
    public func fetchAttendanceSchedule() -> AnyPublisher<BaseEntity<AttendanceScheduleEntity>, Error> {
        opRequestObjectInCombine(AttendanceAPI.lecture)
//        test.requestObjectInCombine(AttendanceAPI.lecture)
    }
    
    public func fetchAttendanceScore() -> AnyPublisher<BaseEntity<AttendanceScoreEntity>, Error> {
        opRequestObjectInCombine(AttendanceAPI.total)
    }
    
    public func fetchAttendanceRound(lectureId: Int) -> AnyPublisher<BaseEntity<AttendanceRoundEntity>, Error> {
        opRequestObjectInCombine(AttendanceAPI.lectureRound(lectureId: lectureId))
    }
    
    public func postAttendance(lectureRoundId: Int, code: String) -> AnyPublisher<BaseEntity<String>, Error> {
        opRequestObjectInCombine(AttendanceAPI.attend(lectureRoundId: lectureRoundId, code: code))
    }
}
