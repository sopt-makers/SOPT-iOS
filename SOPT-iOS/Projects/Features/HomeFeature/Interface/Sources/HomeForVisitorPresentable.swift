//
//  HomeForVisitorPresentable.swift
//  HomeFeatureInterface
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import BaseFeatureDependency
import Core

public protocol HomeForVisitorViewControllable: ViewControllable { }
public protocol HomeForVisitorCoordinatable {
    
}
public typealias HomeForVisitorViewModelType = ViewModelType & HomeForVisitorCoordinatable
public typealias HomeForVisitorPresentable = (vc: HomeForVisitorViewControllable, vm: any HomeForVisitorViewModelType)
