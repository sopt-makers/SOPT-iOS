//
//  NotificationDetailPresentable.swift
//  NotificationFeatureInterface
//
//  Created by Junho Lee on 2023/06/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core
import Domain

public protocol NotificationDetailViewControllable: ViewControllable { }

public protocol NotificationDetailCoordinatable {
    var onShortCutButtonTap: ((ShortCutLink) -> Void)? { get set }
}

public typealias ShortCutLink = (url: String, isDeepLink: Bool)

public typealias NotificationDetailViewModelType = ViewModelType & NotificationDetailCoordinatable
public typealias NotificationDetailPresentable = (vc: NotificationDetailViewControllable, vm: any NotificationDetailViewModelType)
