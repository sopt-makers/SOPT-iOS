//
//  ListDetailPresentable.swift
//  StampFeature
//
//  Created by Jae Hyun Lee on 6/2/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import BaseFeatureDependency
import Domain

public protocol LegacyListDetailViewControllable: LegacyViewControllable & ListDetailCoordinatable { }
public protocol ListDetailCoordinatable {
  var onComplete: ((StarViewLevel, (() -> Void)?) -> Void)? { get set }
  var onNaviBackTap: (() -> Void)? { get set }
}
public typealias ListDetailViewModelType = ViewModelType & ListDetailCoordinatable
public typealias ListDetailPresentable = (vc: UIViewController, vm: any ListDetailViewModelType)
