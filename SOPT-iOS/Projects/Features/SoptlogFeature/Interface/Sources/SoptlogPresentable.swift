//
//  SoptlogPresentable.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import BaseFeatureDependency
import Core

public protocol SoptlogViewControllable: ViewControllable { }
public protocol SoptlogCoordinatable {
    
}
public typealias SoptlogViewModelType = ViewModelType & SoptlogCoordinatable
public typealias SoptlogPresentable = (vc: SoptlogViewControllable, vm: any SoptlogViewModelType)
