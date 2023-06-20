//
//  MainPresentable.swift
//  MainFeatureInterface
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core

public protocol MainViewControllable: ViewControllable { }
public protocol MainCoordinatable { }
public typealias MainViewModelType = ViewModelType & MainCoordinatable
public typealias MainPresentable = (vc: MainViewControllable, vm: any MainViewModelType)
