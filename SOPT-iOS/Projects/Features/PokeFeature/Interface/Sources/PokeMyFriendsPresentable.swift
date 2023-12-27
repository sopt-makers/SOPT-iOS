//
//  PokeMyFriendsPresentable.swift
//  PokeFeatureInterface
//
//  Created by sejin on 12/14/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core
import Domain

public protocol PokeMyFriendsViewControllable: ViewControllable { }

public protocol PokeMyFriendsCoordinatable {
    var showFriendsListButtonTap: ((PokeRelation) -> Void)? { get set }
    var onPokeButtonTapped: ((PokeUserModel) -> Driver<(PokeUserModel, PokeMessageModel)>)? { get set }
    var onProfileImageTapped: ((Int) -> Void)? { get set }
}

public typealias PokeMyFriendsViewModelType = ViewModelType & PokeMyFriendsCoordinatable
public typealias PokeMyFriendsPresentable = (vc: PokeMyFriendsViewControllable, vm: any PokeMyFriendsViewModelType)
