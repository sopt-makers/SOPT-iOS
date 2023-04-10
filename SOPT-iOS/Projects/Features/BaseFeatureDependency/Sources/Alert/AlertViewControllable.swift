//
//  AlertViewControllable.swift
//  BaseFeatureDependency
//
//  Created by Junho Lee on 2023/04/11.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core

public protocol AlertViewControllable: ViewControllable { }

public protocol AlertViewBuildable {
    func makeAlertVC(type: AlertType,
                     title: String,
                     description: String,
                     customButtonTitle: String,
                     customAction: (() -> Void)?) -> AlertViewControllable
    func makeNetworkAlertVC() -> AlertViewControllable
}
