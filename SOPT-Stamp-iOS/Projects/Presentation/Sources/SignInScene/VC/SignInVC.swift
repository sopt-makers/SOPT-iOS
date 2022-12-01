//
//  SignInVC.swift
//  Presentation
//
//  Created by devxsby on 2022/12/01.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Combine
import SnapKit
import Then

public class SignInVC: UIViewController {
    
    // MARK: - Properties
    
    public var viewModel: SignInViewModel!
    private var cancelBag = Set<AnyCancellable>()
  
    // MARK: - UI Components
  
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
    }
}

// MARK: - Methods

extension SignInVC {
  
    private func bindViewModels() {
        let input = SignInViewModel.Input()
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }

}
