//
//  LegacyShowAttendanceViewControllable.swift
//  AttendanceFeature
//
//  Created by Jae Hyun Lee on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core
import Domain

public protocol LegacyShowAttendanceViewControllable: LegacyViewControllable & ShowAttendanceCoordinatable { }
public protocol ShowAttendanceViewControllable: UIViewController & ShowAttendanceCoordinatable { }
public protocol ShowAttendanceCoordinatable {
    var onAttendanceButtonTap: ((AttendanceRoundModel, (() -> Void)?) -> Void)? { get set }
    var onNaviBackTap: (() -> Void)? { get set }
}
public typealias ShowAttendanceViewModelType = ViewModelType & ShowAttendanceCoordinatable
// TODO: coordinating vc -> vm 위임 시 활용
public typealias ShowAttendancePresentable = (vc: ShowAttendanceViewControllable, vm: any ShowAttendanceViewModelType)
