//
//  PokeNotificationPresentable.swift
//  PokeFeatureDemo
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core
import Domain

public protocol PokeNotificationViewControllable: LegacyViewControllable { }

public protocol PokeNotificationRoutingTrigger {
    var onNaviBackTapped: (() -> Void)? { get set }
    var onPokeButtonTapped: ((PokeUserModel) -> Driver<(PokeUserModel, PokeMessageModel, isAnonymous: Bool)>)? { get set }
    var onNewFriendAdded: ((_ friendName: String) -> Void)? { get set }
    var onAnonymousFriendUpgrade: ((PokeUserModel) -> Void)? { get set }
    var onProfileImageTapped: ((Int) -> Void)? { get set }
}

public typealias PokeNotificationViewModelType = ViewModelType & PokeNotificationRoutingTrigger
public typealias LegacyPokeNotificationPresentable = (vc: PokeNotificationViewControllable, vm: any PokeNotificationViewModelType)

public typealias PokeNotificationPresentable = (vc: UIViewController, vm: any PokeNotificationViewModelType)
