//
//  MainPresentable.swift
//  MainFeatureInterface
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import BaseFeatureDependency
import Core

public protocol MainViewControllable: ViewControllable { }
public protocol MainCoordinatable {
    var onNoticeButtonTap: (() -> Void)? { get set }
    var onMyPageButtonTap: ((UserType) -> Void)? { get set }
    var onSoptamp: (() -> Void)? { get set }
    var onPoke: (() -> Void)? { get set }
    var onSafari: ((String) -> Void)? { get set }
    var onAttendance: (() -> Void)? { get set }
    var onNeedSignIn: (() -> Void)? { get set }
}
public typealias MainViewModelType = ViewModelType & MainCoordinatable
public typealias MainPresentable = (vc: MainViewControllable, vm: any MainViewModelType)
