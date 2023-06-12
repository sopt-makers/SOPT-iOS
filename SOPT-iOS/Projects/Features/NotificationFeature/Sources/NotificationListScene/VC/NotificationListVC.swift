//
//  NotificationListVC.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/12.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import NotificationFeatureInterface

public final class NotificationListVC: UIViewController, NotificationListViewControllable {
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
    }
}
