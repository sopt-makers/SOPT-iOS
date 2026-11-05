//
//  ShowAttendanceViewControllable.swift
//  AttendanceFeature
//
//  Created by Jae Hyun Lee on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core
import Domain

public protocol ShowAttendanceCoordinatable {
    var onAttendanceButtonTap: ((AttendanceRoundModel, (() -> Void)?) -> Void)? { get set }
    var onNaviBackTap: (() -> Void)? { get set }
    var onInfoButtonTap: (() -> Void)? { get set }
}
public typealias ShowAttendanceViewModelType = ViewModelType & ShowAttendanceCoordinatable
public typealias ShowAttendancePresentable = (vc: UIViewController, vm: any ShowAttendanceViewModelType)
