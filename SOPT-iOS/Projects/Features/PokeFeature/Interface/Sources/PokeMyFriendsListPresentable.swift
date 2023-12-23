//
//  PokeMyFriendsListPresentable.swift
//  PokeFeatureInterface
//
//  Created by sejin on 12/21/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core
import Domain

public protocol PokeMyFriendsListViewControllable: ViewControllable { }

public protocol PokeMyFriendsListCoordinatable {
    var onCloseButtonTap: (() -> Void)? { get set }
}

public protocol PokeMyFriendsListViewModelType: ViewModelType & PokeMyFriendsListCoordinatable {
    var relation: PokeRelation { get }
    var onPokeButtonTapped: ((PokeUserModel) -> Driver<(PokeUserModel, PokeMessageModel)>)? { get set }
    var onProfileImageTapped: ((Int) -> Void)? { get set }
}

public typealias PokeMyFriendsListPresentable = (vc: PokeMyFriendsListViewControllable, vm: any PokeMyFriendsListViewModelType)
