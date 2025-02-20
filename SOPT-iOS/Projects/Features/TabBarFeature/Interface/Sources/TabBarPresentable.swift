//
//  TabBarPresentable.swift
//  TabBarFeatureDemo
//
//  Created by 강윤서 on 2/20/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import UIKit

import BaseFeatureDependency
import Core

public protocol TabBarCoordinatable {
    var onTabBarItemTapped: ((Int) -> Void)? { get set }
}
public typealias TabBarViewModelType = ViewModelType & TabBarCoordinatable
public typealias TabBarPresentable = (vc: UITabBarController, vm: any TabBarViewModelType)
