//
//  PokeMainPresentable.swift
//  PokeFeatureInterface
//
//  Created by sejin on 12/7/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core
import Domain

public protocol PokeMainViewControllable: ViewControllable { }

public protocol PokeMainRoutingTrigger {
  var onPokeNotificationsTap: (() -> Void)? { get set }
  var onMyFriendsTap: (() -> Void)? { get set }
  var onProfileImageTapped: ((Int) -> Void)? { get set }
  var onPokeButtonTapped: ((PokeUserModel) -> Driver<(PokeUserModel, PokeMessageModel, isAnonymous: Bool)>)? { get set }
  var onNewFriendMade: ((String) -> Void)? { get set }
  var onAnonymousFriendUpgrade: ((PokeUserModel) -> Void)? { get set }
  var onPokeOnboardingNeeded: ((Bool) -> Void)? { get set }
}

public typealias PokeMainViewModelType = ViewModelType & PokeMainRoutingTrigger

public typealias PokeMainPresentable = (vc: UIViewController, vm: any PokeMainViewModelType)
