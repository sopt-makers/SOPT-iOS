//
//  ShowAttendanceVC.swift
//  AttendanceFeature
//
//  Created by devxsby on 2023/04/11.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Combine

import Core
import DSKit

import SnapKit
import AttendanceFeatureInterface

public class ShowAttendanceVC: UIViewController, ShowAttendanceViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: ShowAttendanceViewModel
    public var factory: AttendanceFeatureViewBuildable
    private var cancelBag = CancelBag()
  
    // MARK: - UI Components
    
    // MARK: - Initialization
    
    public init(viewModel: ShowAttendanceViewModel, factory: AttendanceFeatureViewBuildable) {
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

extension ShowAttendanceVC {
    private func setUI() {
        self.view.backgroundColor = .black
    }
    
    private func setLayout() {
        
    }
}

// MARK: - Methods

extension ShowAttendanceVC {
  
    private func bindViewModels() {
        let input = ShowAttendanceViewModel.Input()
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }

}
