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

// TODO: - 화면전환 트리거 책임 vc -> vm으로 변경하기

public protocol LegacyListDetailViewControllable: LegacyViewControllable & ListDetailRoutingTrigger { }
public protocol ListDetailViewControllable: UIViewController & ListDetailRoutingTrigger { }
public protocol ListDetailRoutingTrigger {
  var onComplete: ((StarViewLevel, (() -> Void)?) -> Void)? { get set }
  var onNaviBackTap: (() -> Void)? { get set }
  var onViewClapTap: ((Int, String) -> Void)? { get set }
}
public typealias ListDetailViewModelType = ViewModelType & ListDetailRoutingTrigger
public typealias ListDetailPresentable = (vc: ListDetailViewControllable, vm: any ListDetailViewModelType)
