//
//  AttendanceFeatureBuildable.swift
//  AttendanceFeatureInterface
//
//  Created by Jae Hyun Lee on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency

import Domain

public protocol AttendanceFeatureBuildable {
    func makeShowAttendanceVC(coordinator: Coordinator) -> ShowAttendancePresentable
    func makeAttendanceVC(
        lectureRound: AttendanceRoundModel,
        dismissCompletion: (() -> Void)?
    ) -> AttendancePresentable
}
