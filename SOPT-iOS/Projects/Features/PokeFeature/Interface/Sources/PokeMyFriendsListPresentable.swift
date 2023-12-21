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
}

public typealias PokeMyFriendsListViewModelType = ViewModelType & PokeMyFriendsListCoordinatable
public typealias PokeMyFriendsListPresentable = (vc: PokeMyFriendsListViewControllable, vm: any PokeMyFriendsListViewModelType)
