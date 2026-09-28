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


public protocol ListDetailViewControllable: ViewControllable { }
public protocol ListDetailRoutingTrigger {
  var onComplete: ((StarViewLevel, (() -> Void)?) -> Void)? { get set }
  var onNaviBackTap: (() -> Void)? { get set }
  var onViewClapListTap: ((Int, String) -> Void)? { get set }
}
public typealias ListDetailViewModelType = ViewModelType & ListDetailRoutingTrigger
public typealias ListDetailPresentable = (vc: UIViewController, vm: any ListDetailViewModelType)
