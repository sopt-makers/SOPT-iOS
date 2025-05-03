//
//  HomeCalendarDetailPresentable.swift
//  HomeFeatureDemo
//
//  Created by 강윤서 on 12/12/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import BaseFeatureDependency
import Core

public protocol HomeCalendarDetailViewControllable: LegacyViewControllable {}
public protocol HomeCalendarDetailCoordinatable {
    var onNaviBackButtonTap: (() -> Void)? { get set }
    var onAttendanceButtonTap: (() -> Void)? { get set }
}
public typealias HomeCalendarDetailViewModelType = ViewModelType & HomeCalendarDetailCoordinatable
public typealias HomeCalendarDetailPresentable = (vc: HomeCalendarDetailViewControllable, vm: any HomeCalendarDetailViewModelType)
