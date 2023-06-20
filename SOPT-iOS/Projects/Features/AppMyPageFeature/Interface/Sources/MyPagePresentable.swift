//
//  MyPagePresentable.swift
//  AppMyPageFeature
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core

public protocol MyPageViewControllable: ViewControllable { }
public protocol MyPageCoordinatable {
    var onNaviBackButtonTap: (() -> Void)? { get set }
}
public typealias MyPageViewModelType = ViewModelType & MyPageCoordinatable
public typealias MyPagePresentable = (vc: MyPageViewControllable, vm: any MyPageViewModelType)
