//
//  HomeForVisitorPresentable.swift
//  HomeFeatureInterface
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core

public protocol HomeForVisitorViewControllable: LegacyViewControllable { }
public protocol HomeForVisitorCoordinatable {
    var onMainProductCellTapped: ((String) -> Void)? { get set }
    var onAppServiceCellTapped: (() -> Void)? { get set }
    var onSettingButtonTapped: ((UserType) -> Void)? { get set }
}
public typealias HomeForVisitorViewModelType = ViewModelType & HomeForVisitorCoordinatable
public typealias LegacyHomeForVisitorPresentable = (vc: HomeForVisitorViewControllable, vm: any HomeForVisitorViewModelType)

public typealias HomeForVisitorPresentable = (vc: UIViewController, vm: any HomeForVisitorViewModelType)
