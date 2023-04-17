//
//  AttendanceVC.swift
//  AttendanceFeature
//
//  Created by 김영인 on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core

import Combine
import SnapKit
import Then

import AttendanceFeatureInterface

public class AttendanceVC: UIViewController, AttendanceViewControllable {

    // MARK: - Properties
    
    public var viewModel: AttendanceViewModel
    private var cancelBag = CancelBag()
    public var factory: AttendanceFeatureViewBuildable
    
    // MARK: - UI Components
    
    // MARK: - Init
    
    public init(viewModel: AttendanceViewModel, factory: AttendanceFeatureViewBuildable) {
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
        
        self.setUI()
        self.setLayout()
        self.bindViewModels()
    }
}

// MARK: - UI & Layouts

extension AttendanceVC {
    
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.85)
    }
    
    private func setLayout() {
        
    }
}

// MARK: - Methods

extension AttendanceVC {
    
    private func bindViewModels() {
        
        let input = AttendanceViewModel.Input()
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
    }
}
