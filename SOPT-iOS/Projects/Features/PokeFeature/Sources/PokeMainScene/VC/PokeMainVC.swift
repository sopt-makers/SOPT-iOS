//
//  PokeMainVC.swift
//  PokeFeature
//
//  Created by sejin on 12/7/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain
import DSKit

import BaseFeatureDependency
import PokeFeatureInterface

public final class PokeMainVC: UIViewController, PokeMainViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: PokeMainViewModel
    private var cancelBag = CancelBag()
    
    // MARK: - initialization
    
    public init(viewModel: PokeMainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.bindViewModel()
    }
}

// MARK: - UI & Layout

extension PokeMainVC {
    private func setUI() {
        view.backgroundColor = .red
    }
    
    private func setLayout() {
    }
}

// MARK: - Methods

extension PokeMainVC {
    private func bindViewModel() {
    }
}
