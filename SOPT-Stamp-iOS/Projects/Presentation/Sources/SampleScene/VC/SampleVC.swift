//
//  SampleVC.swift
//  Network
//
//  Created by Junho Lee on 2022/11/09.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core

import Combine
import SnapKit
import Then

public class SampleVC: UIViewController {
    
    // MARK: - Properties
    
    public var viewModel: SampleViewModel!
    private var cancelBag = CancelBag()
  
    // MARK: - UI Components
  
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
    }
}

// MARK: - Methods

extension SampleVC {
  
    private func bindViewModels() {
        let input = SampleViewModel.Input()
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }

}
