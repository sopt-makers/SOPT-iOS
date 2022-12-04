//
//  RankingVC.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core

import Combine
import SnapKit
import Then

public class RankingVC: UIViewController {
    
    // MARK: - Properties
    
    public var viewModel: RankingViewModel!
    private var cancelBag = CancelBag()
  
    // MARK: - UI Components
  
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
    }
}

// MARK: - Methods

extension RankingVC {
  
    private func bindViewModels() {
        let input = RankingViewModel.Input()
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }

}
