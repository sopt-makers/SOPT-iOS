//
//  OnboardingVC.swift
//  Presentation
//
//  Created by devxsby on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import DSKit

import SnapKit
import Then

public class OnboardingVC: UIViewController {
    
    // MARK: - Properties
    
    public var factory: ModuleFactoryInterface!
  
    // MARK: - UI Components
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
    }
}

// MARK: - UI & Layout

extension OnboardingVC {
    
    private func setUI() {
        self.view.backgroundColor = DSKitAsset.Colors.white.color
    }
    
    private func setLayout() {
        
    }
}

// MARK: - Methods
