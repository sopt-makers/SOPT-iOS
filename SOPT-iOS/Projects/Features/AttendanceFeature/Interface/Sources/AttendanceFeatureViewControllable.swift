//
//  AttendanceFeatureViewControllable.swift
//  AttendanceFeature
//
//  Created by 김영인 on 2023/03/18.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency

import Domain

public protocol ShowAttendanceViewControllable: ViewControllable & ShowAttendanceCoordinatable { }
public protocol ShowAttendanceCoordinatable {
    var onAttendanceButtonTap: ((AttendanceRoundModel, (() -> Void)?) -> Void)? { get set }
    var onNaviBackTap: (() -> Void)? { get set }
}
public protocol AttendanceViewControllable: ViewControllable { }
