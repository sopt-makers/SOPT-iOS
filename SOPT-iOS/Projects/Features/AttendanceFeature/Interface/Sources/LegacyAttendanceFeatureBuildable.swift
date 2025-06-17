//
//  LegacyAttendanceFeatureBuildable.swift
//  AttendanceFeatureInterface
//
//  Created by Junho Lee on 2023/06/22.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency

import Domain

public protocol LegacyAttendanceFeatureBuildable {
    func makeShowAttendanceVC() -> LegacyShowAttendanceViewControllable
    func makeAttendanceVC(
        lectureRound: AttendanceRoundModel,
        dismissCompletion: (() -> Void)?
    ) -> LegacyAttendanceViewControllable
}
