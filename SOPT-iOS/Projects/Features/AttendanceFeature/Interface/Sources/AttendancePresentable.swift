//
//  AttendancePresentable.swift
//  AttendanceFeature
//
//  Created by 김영인 on 2023/03/18.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core
import Domain

public protocol LegacyAttendanceViewControllable: LegacyViewControllable { }
public protocol AttendanceViewControllable: UIViewController { }

public typealias AttendanceViewModelType = ViewModelType
public typealias AttendancePresentable = (vc: AttendanceViewControllable, vm: any AttendanceViewModelType)
