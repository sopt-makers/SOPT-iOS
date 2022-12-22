//
//  SentenceEditVC.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/22.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core

import Combine
import SnapKit
import Then

public class SentenceEditVC: UIViewController {
    
    // MARK: - Properties
    
    public var viewModel: SentenceEditViewModel!
    private var cancelBag = CancelBag()
  
    // MARK: - UI Components
  
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
    }
}

// MARK: - Methods

extension SentenceEditVC {
  
    private func bindViewModels() {
        let input = SentenceEditViewModel.Input()ㄱ
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }

}
