//
//  PasswordChangeVC.swift
//  Presentation
//
//  Created by sejin on 2022/12/26.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Combine

import Core
import SnapKit
import Then

public class PasswordChangeVC: UIViewController {
    
    // MARK: - Properties
    
    public var viewModel: PasswordChangeViewModel!
    private var cancelBag = CancelBag()
  
    // MARK: - UI Components
  
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
    }
}

// MARK: - Methods

extension PasswordChangeVC {
  
    private func bindViewModels() {
        let input = PasswordChangeViewModel.Input()
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }

}
