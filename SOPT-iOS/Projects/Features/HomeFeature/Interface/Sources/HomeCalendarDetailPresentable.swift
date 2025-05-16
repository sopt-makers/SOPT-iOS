//
//  HomeCalendarDetailPresentable.swift
//  HomeFeatureDemo
//
//  Created by 강윤서 on 12/12/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core

public protocol HomeCalendarDetailViewControllable: LegacyViewControllable {}
public protocol HomeCalendarDetailCoordinatable {
    var onNaviBackButtonTap: (() -> Void)? { get set }
    var onAttendanceButtonTap: (() -> Void)? { get set }
}
public typealias HomeCalendarDetailViewModelType = ViewModelType & HomeCalendarDetailCoordinatable
public typealias LegacyHomeCalendarDetailPresentable = (vc: HomeCalendarDetailViewControllable, vm: any HomeCalendarDetailViewModelType)

public typealias HomeCalendarDetailPresentable = (vc: UIViewController, vm: any HomeCalendarDetailViewModelType)
