//
//  DailySoptuneResultVC.swift
//  DailySoptuneFeature
//
//  Created by Jae Hyun Lee on 9/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain
import DSKit

import BaseFeatureDependency
import DailySoptuneFeatureInterface

public final class DailySoptuneResultVC: UIViewController, DailySoptuneResultViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: DailySoptuneResultViewModel
    private var cancelBag = CancelBag()
    
    // MARK: - Initialization
    
    public init(viewModel: DailySoptuneResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.bindViewModel()
    }
}

// MARK: - UI & Layout

extension DailySoptuneResultVC {
    private func setUI() {
        view.backgroundColor = .red
    }
    
    private func setLayout() {
    }
}

// MARK: - Methods

extension DailySoptuneResultVC {
    private func bindViewModel() {
    }
}
