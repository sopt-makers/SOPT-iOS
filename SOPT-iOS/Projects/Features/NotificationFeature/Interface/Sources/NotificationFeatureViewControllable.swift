//
//  NotificationFeatureViewControllable.swift
//  ProjectDescriptionHelpers
//
//  Created by sejin on 2023/06/12.
//

import BaseFeatureDependency
import Core

public protocol NotificationListViewControllable: ViewControllable { }

public protocol NotificationFeatureViewBuildable {
    func makeNotificationListVC() -> NotificationListViewControllable
}
