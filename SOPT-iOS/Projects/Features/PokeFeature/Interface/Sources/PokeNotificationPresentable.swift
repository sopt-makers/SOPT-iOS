//
//  PokeNotificationPresentable.swift
//  PokeFeatureDemo
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core
import Domain

public protocol PokeNotificationViewControllable: ViewControllable { }

public protocol PokeNotificationCoordinatable {
    var onNaviBackTapped: (() -> Void)? { get set }
    var onPokeButtonTapped: ((PokeUserModel) -> Driver<(PokeUserModel, PokeMessageModel, isAnonymous: Bool)>)? { get set }
    var onNewFriendAdded: ((_ friendName: String) -> Void)? { get set }
    var onAnonymousFriendUpgrade: ((PokeUserModel) -> Void)? { get set }
}

public typealias PokeNotificationViewModelType = ViewModelType & PokeNotificationCoordinatable
public typealias PokeNotificationPresentable = (vc: PokeNotificationViewControllable, vm: any PokeNotificationViewModelType)

