//
//  HomeForMemberPresentable.swift
//  HomeFeatureInterface
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import BaseFeatureDependency
import Core

public protocol HomeForMemberViewControllable: ViewControllable { }
public protocol HomeForMemberCoordinatable {
    var onDashBoardCellTapped: (() -> Void)? { get set }
    var onCalendarCellTapped: (() -> Void)? { get set }
    var onAttendanceButtonTapped: (() -> Void)? { get set }
    var onMainProductCellTapped: ((String) -> Void)? { get set }
    var onAppServiceCellTapped: ((String) -> Void)? { get set }
    var onNotificationButtonTapped: (() -> Void)? { get set }
    var onSettingButtonTapped: ((UserType) -> Void)? { get set }
}
public typealias HomeForMemberViewModelType = ViewModelType & HomeForMemberCoordinatable
public typealias HomeForMemberPresentable = (vc: HomeForMemberViewControllable, vm: any HomeForMemberViewModelType)
