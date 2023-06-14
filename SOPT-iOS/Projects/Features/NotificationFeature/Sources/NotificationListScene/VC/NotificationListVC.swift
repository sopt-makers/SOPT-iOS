//
//  NotificationListVC.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/12.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit

import Combine

import BaseFeatureDependency
import NotificationFeatureInterface

public final class NotificationListVC: UIViewController, NotificationListViewControllable {
    
    public typealias factoryType = NotificationFeatureViewBuildable
    & AlertViewBuildable

    // MARK: - Properties
    
    public var viewModel: NotificationListViewModel!
    public var factory: factoryType!
    private var cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.bindViewModels()
    }
}

// MARK: - UI & Layout

extension NotificationListVC {
    private func setUI() {
        view.backgroundColor = .brown
    }
    
    private func setLayout() {
    }
}

// MARK: - Methods

extension NotificationListVC {
    private func bindViewModels() {
    }
}
