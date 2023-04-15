//
//  ShowAttendanceRepositoryInterface.swift
//  Domain
//
//  Created by devxsby on 2023/04/11.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

public protocol ShowAttendanceRepositoryInterface {
    func fetchAttendanceScheduleModel() -> AnyPublisher<AttendanceScheduleModel, Error>
    func fetchAttendanceScoreModel() -> AnyPublisher<AttendanceScoreModel, Error>
}
