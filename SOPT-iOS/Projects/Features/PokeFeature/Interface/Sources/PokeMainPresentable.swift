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
}

public typealias PokeMainViewModelType = ViewModelType & PokeMainCoordinatable
public typealias NotificationDetailPresentable = (vc: PokeMainViewControllable, vm: any PokeMainViewModelType)
