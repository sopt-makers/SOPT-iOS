//
//  AlertViewControllable.swift
//  BaseFeatureDependency
//
//  Created by Junho Lee on 2023/04/11.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core

public protocol AlertViewControllable: LegacyViewControllable { }

public protocol AlertViewBuildable {
    func makeAlertVC(type: AlertType,
                     theme: AlertVC.AlertTheme,
                     title: String,
                     description: String,
                     customButtonTitle: String,
                     customAction: (() -> Void)?) -> AlertViewControllable
    func makeNetworkAlertVC(theme: AlertVC.AlertTheme) -> AlertViewControllable
}
