//
//  PokeMainPresentable.swift
//  PokeFeatureInterface
//
//  Created by sejin on 12/7/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core
import Domain

public protocol PokeMainViewControllable: ViewControllable { }

public protocol PokeMainCoordinatable {
  var onNaviBackTap: (() -> Void)? { get set }
  var onPokeNotificationsTap: (() -> Void)? { get set }
  var onMyFriendsTap: (() -> Void)? { get set }
  var onProfileImageTapped: ((Int) -> Void)? { get set }
  var onPokeButtonTapped: ((PokeUserModel) -> Driver<(PokeUserModel, PokeMessageModel, isAnonymous: Bool)>)? { get set }
  var onNewFriendMade: ((String) -> Void)? { get set }
  var onAnonymousFriendUpgrade: ((PokeUserModel) -> Void)? { get set }
  var switchToOnboarding: (() -> Void)? { get set }
}

public typealias PokeMainViewModelType = ViewModelType & PokeMainCoordinatable
public typealias PokeMainPresentable = (vc: PokeMainViewControllable, vm: any PokeMainViewModelType)
