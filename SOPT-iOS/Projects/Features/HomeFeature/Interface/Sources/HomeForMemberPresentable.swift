//
//  HomeForMemberPresentable.swift
//  HomeFeatureInterface
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core

public protocol HomeForMemberViewControllable: LegacyViewControllable { }
public protocol HomeForMemberCoordinatable {
    var onDashBoardCellTapped: (() -> Void)? { get set }
    var onCalendarCellTapped: (() -> Void)? { get set }
    var onAttendanceButtonTapped: (() -> Void)? { get set }
    var onMainProductCellTapped: ((String) -> Void)? { get set }
    var onAppServiceCellTapped: ((String) -> Void)? { get set }
    var onNotificationButtonTapped: (() -> Void)? { get set }
    var onSettingButtonTapped: ((UserType) -> Void)? { get set }
    var onNeedSignIn: (() -> Void)? { get set }
    var onNetworkError: (() -> Void)? { get set }
    var onPoke: ((_ isNewUser: Bool) -> Void)? { get set }
    var onExtendedFloatingButtonTapped: ((String) -> Void)? { get set }
    var onSurveyButtonTapped: ((String) -> Void)? { get set }
    var onSocialLinkButtonTapped: ((String) -> Void)? { get set }
    var onPopularPostCellTapped: ((String) -> Void)? { get set }
    var onLatestPostCellTapped: ((String) -> Void)? { get set }
    var onViewAllContentButtonTapped: ((String) -> Void)? { get set }
    var onProfileImageViewTapped: ((Int) -> Void)? { get set }
    var onFABMenuTapped: ((String) -> Void)? { get set }
    var onEditProfileTapped: ((String) -> Void)? { get set }
}
public typealias HomeForMemberViewModelType = ViewModelType & HomeForMemberCoordinatable
public typealias LegacyHomeForMemberPresentable = (vc: HomeForMemberViewControllable, vm: any HomeForMemberViewModelType)

public typealias HomeForMemberPresentable = (vc: UIViewController, vm: any HomeForMemberViewModelType)
