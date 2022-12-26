//
//  PasswordChangeVC.swift
//  Presentation
//
//  Created by sejin on 2022/12/26.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Combine
import SnapKit
import Then

import Core
import Domain
import DSKit

public class PasswordChangeVC: UIViewController {
    
    // MARK: - Properties
    
    public var factory: ModuleFactoryInterface!
    public var viewModel: PasswordChangeViewModel!
    private var cancelBag = CancelBag()
  
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .titleWithLeftButton)
        .setTitle(I18N.Setting.passwordEdit)
        .setTitleTypoStyle(.h1)
    
    private lazy var passwordTextFieldView = CustomTextFieldView(type: .title)
        .setTitle(I18N.SignUp.password)
        .setTextFieldType(.password)
        .setPlaceholder(I18N.SignUp.passwordTextFieldPlaceholder)
        .setAlertDelegate(passwordCheckTextFieldView)
    
    private lazy var passwordCheckTextFieldView = CustomTextFieldView(type: .plain)
        .setPlaceholder(I18N.SignUp.passwordCheckTextFieldPlaceholder)
        .setTextFieldType(.password)
        .setAlertLabelEnabled(I18N.SignUp.invalidPasswordForm)
    
    private let passwordChangeButton = CustomButton(title: I18N.Setting.passwordEdit)
        .setEnabled(false)
  
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
        self.setUI()
        self.setLayout()
    }
}

// MARK: - Methods

extension PasswordChangeVC {
  
    private func bindViewModels() {
        let input = PasswordChangeViewModel.Input()
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }

}

// MARK: - UI & Layout

extension PasswordChangeVC {
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setLayout() {
        self.view.addSubviews(naviBar, passwordTextFieldView, passwordCheckTextFieldView, passwordChangeButton)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        passwordTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        passwordCheckTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(passwordTextFieldView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        passwordChangeButton.snp.makeConstraints { make in
            make.top.equalTo(passwordCheckTextFieldView.snp.bottom).offset(26)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
    }
}
