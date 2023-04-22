//
//  AttendanceFeatureViewControllable.swift
//  AttendanceFeature
//
//  Created by 김영인 on 2023/03/18.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency

import Domain

public protocol ShowAttendanceViewControllable: ViewControllable { }

public protocol AttendanceViewControllable: ViewControllable { }

public protocol AttendanceFeatureViewBuildable {
    func makeShowAttendanceVC() -> ShowAttendanceViewControllable
    func makeAttendanceVC(lectureRound: AttendanceRoundModel) -> AttendanceViewControllable
}
