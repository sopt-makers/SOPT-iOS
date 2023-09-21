//
//  NicknameEditVC.swift
//  Presentation
//
//  Created by Junho Lee on 2023/01/02.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

import Combine
import SnapKit
import Then

import BaseFeatureDependency

public class NicknameEditVC: UIViewController, NicknameEditViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: NicknameEditViewModel!
    private var cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    private lazy var navigationBar = OPNavigationBar(
            self,
            type: .oneLeftButton,
            backgroundColor: DSKitAsset.Colors.black100.color
        )
        .addMiddleLabel(title: I18N.Setting.NicknameEdit.nicknameEdit)
    
    private let nicknameTextFieldView = AppTextFieldView(type: .plain)
        .setTitle(I18N.SignUp.nickname)
        .setMaxLength(10)
        .setPlaceholder(I18N.SignUp.nicknameTextFieldPlaceholder)
        .setAlertLabelEnabled(I18N.SignUp.duplicatedNickname)
    
    private let editNicknameButton = AppCustomButton(title: I18N.Setting.NicknameEdit.nicknameEdit)
        .setEnabled(false)
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
        self.setUI()
        self.setLayout()
        self.hideKeyboard()
    }
}

// MARK: - Methods

extension NicknameEditVC {
    
    private func bindViewModels() {
        let nicknameTextChanged = nicknameTextFieldView
            .textChanged
            .compactMap { $0 }
            .eraseToAnyPublisher()
            .asDriver()
        
        let editNicknameButtonTapped = self.editNicknameButton
            .publisher(for: .touchUpInside)
            .compactMap { _ in self.nicknameTextFieldView.text }
            .filter { !$0.isEmpty }
            .asDriver()
        
        let input = NicknameEditViewModel.Input(nicknameTextChanged: nicknameTextChanged,
                                                editButtonTapped: editNicknameButtonTapped)
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.nicknameAlert
            .dropFirst()
            .map { $0.convertToTextFieldAlertType() }
            .assign(to: nicknameTextFieldView.kf.alertType,
                    on: nicknameTextFieldView)
            .store(in: cancelBag)
        
        output.$editButtonEnabled
            .assign(to: self.editNicknameButton.kf.isEnabled, on: self.editNicknameButton)
            .store(in: self.cancelBag)
        
        output.editNicknameSuccessed
            .withUnretained(self)
            .sink { owner, isSuccessed in
                if isSuccessed {
                    owner.showToastAndPopView()
                } else {
                    owner.showNetworkAlert()
                }
            }.store(in: self.cancelBag)
    }
    
    private func showToastAndPopView() {
        self.navigationController?.popViewController(animated: true)
        let window = self.view.window!
        Toast.show(message: I18N.Setting.NicknameEdit.nicknameEditSuccess,
                   view: window,
                   safeAreaBottomInset: self.safeAreaBottomInset())
    }
    
    public func showNetworkAlert() {
        AlertUtils.presentNetworkAlertVC(
            theme: .main,
            animated: true
        )
    }
}

// MARK: - UI & Layout

extension NicknameEditVC {
    private func setUI() {
        self.view.backgroundColor = DSKitAsset.Colors.black100.color
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setLayout() {
        self.view.addSubviews(navigationBar, nicknameTextFieldView, editNicknameButton)
        
        navigationBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        nicknameTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(12.adjustedH)
            make.leading.trailing.equalToSuperview().inset(20.adjusted)
        }
        
        editNicknameButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextFieldView.snp.bottom).offset(26.adjustedH)
            make.leading.trailing.equalToSuperview().inset(20.adjusted)
            make.height.equalTo(56.adjustedH)
        }
    }
}
