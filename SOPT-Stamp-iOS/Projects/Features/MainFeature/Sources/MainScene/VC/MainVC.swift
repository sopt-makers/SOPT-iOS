//
//  MainVC.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

import Combine
import SnapKit
import Then

import MainFeatureInterface
import StampFeatureInterface

public class MainVC: UIViewController, MainViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: MainViewModel!
    public var factory: StampFeatureViewBuildable!
    
    private var cancelBag = CancelBag()
  
    // MARK: - UI Components
  
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
        self.setUI()
        self.setLayout()
    }
}

// MARK: - UI & Layout

extension MainVC {
    private func setUI() {
        view.backgroundColor = .green
    }
    
    private func setLayout() {
        
    }
}

// MARK: - Methods

extension MainVC {
    private func bindViewModels() {
        let input = MainViewModel.Input()
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }
}
