//
//  AttendanceService.swift
//  Network
//
//  Created by devxsby on 2023/04/11.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Alamofire
import Moya

public typealias DefaultAttendanceService = BaseService<AttendanceAPI>

public protocol AttendanceService {
    func fetchAttendanceSchedule() -> AnyPublisher<BaseEntity<AttendanceScheduleEntity>, Error>
    func fetchAttendanceScore() -> AnyPublisher<BaseEntity<AttendanceScoreEntity>, Error>
}

extension DefaultAttendanceService: AttendanceService {
    
    public func fetchAttendanceSchedule() -> AnyPublisher<BaseEntity<AttendanceScheduleEntity>, Error> {
        requestObjectInCombine(AttendanceAPI.lecture)
    }
    
    public func fetchAttendanceScore() -> AnyPublisher<BaseEntity<AttendanceScoreEntity>, Error> {
        requestObjectInCombine(AttendanceAPI.total)
    }
}
