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
    func fetchLectureRound(lectureId: Int) -> AnyPublisher<Int, Error>
    func postAttendance(lectureRoundId: Int, code: Int) -> AnyPublisher<Bool, Error>
}
