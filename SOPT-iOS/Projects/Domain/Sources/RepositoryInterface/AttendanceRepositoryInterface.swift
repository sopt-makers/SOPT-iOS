//
//  AttendanceRepositoryInterface.swift
//  Domain
//
//  Created by 김영인 on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol AttendanceRepositoryInterface {
    func postAttendance(lectureRoundId: Int, code: String) -> AnyPublisher<Bool, Error>
}
