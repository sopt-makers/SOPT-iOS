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
    
    lazy var naviBar = OPNavigationBar(self, type: .bothButtons)
        .addRightButton(with: nil)
        .addRightButton(with: "모두 읽음", titleColor: DSKitAsset.Colors.purple100.color)
    
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
        view.backgroundColor = DSKitAsset.Colors.black100.color
    }
    
    private func setLayout() {
        self.view.addSubviews(naviBar)
        
        naviBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension NotificationListVC {
    private func bindViewModels() {
    }
}
