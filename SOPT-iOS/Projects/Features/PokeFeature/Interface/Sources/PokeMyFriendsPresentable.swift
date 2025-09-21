//
//  PokeMyFriendsPresentable.swift
//  PokeFeatureInterface
//
//  Created by sejin on 12/14/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core
import Domain

public protocol PokeMyFriendsViewControllable: LegacyViewControllable { }

public protocol PokeMyFriendsRoutingTrigger {
    var showFriendsListButtonTap: ((PokeRelation) -> Void)? { get set }
    var onPokeButtonTapped: ((PokeUserModel) -> Driver<(PokeUserModel, PokeMessageModel, isAnonymous: Bool)>)? { get set }
    var onProfileImageTapped: ((Int) -> Void)? { get set }
    var onAnonymousFriendUpgrade: ((PokeUserModel) -> Void)? { get set }
}

public typealias PokeMyFriendsViewModelType = ViewModelType & PokeMyFriendsRoutingTrigger
public typealias LegacyPokeMyFriendsPresentable = (vc: PokeMyFriendsViewControllable, vm: any PokeMyFriendsViewModelType)

public typealias PokeMyFriendsPresentable = (vc: UIViewController, vm: any PokeMyFriendsViewModelType)
