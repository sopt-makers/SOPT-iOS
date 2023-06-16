//
//  NotificationDetailVC.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

import Combine
import SnapKit
import Then

import BaseFeatureDependency
import NotificationFeatureInterface

public final class NotificationDetailVC: UIViewController, NotificationDetailViewControllable {
    
    public typealias factoryType = AlertViewBuildable
    
    // MARK: - Properties
    
    public var viewModel: NotificationDetailViewModel
    public var factory: factoryType
    private var cancelBag = CancelBag()
  
    // MARK: - UI Components
    
    private lazy var naviBar = OPNavigationBar(self, type: .oneLeftButton)
        .addMiddleLabel(title: I18N.Notification.notification)
    
    // MARK: - initialization
    
    public init(viewModel: NotificationDetailViewModel, factory: factoryType) {
        self.viewModel = viewModel
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
        self.setUI()
        self.setLayout()
    }
}

// MARK: - UI & Layout

extension NotificationDetailVC {
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

extension NotificationDetailVC {
  
    private func bindViewModels() {
        let input = NotificationDetailViewModel.Input()
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }
}
