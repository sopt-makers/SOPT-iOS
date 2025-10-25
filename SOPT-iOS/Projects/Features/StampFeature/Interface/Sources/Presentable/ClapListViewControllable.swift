//
//  ClapListViewControllable.swift
//  StampFeature
//
//  Created by 성현주 on 10/22/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import BaseFeatureDependency
import Domain

// MARK: - ViewControllable

public protocol ClapListViewControllable: UIViewController & ClapListRoutingTrigger { }

// MARK: - RoutingTrigger

public protocol ClapListRoutingTrigger {
    var onNaviBackTap: (() -> Void)? { get set }
    var onCellTap: ((String?) -> Void)? { get set }
}

// MARK: - ViewModelType

public typealias ClapListViewModelType = ViewModelType & ClapListRoutingTrigger

// MARK: - Presentable

public typealias ClapListPresentable = (
    vc: any ClapListViewControllable,
    vm: any ClapListViewModelType
)
