//
//  WithdrawalVC.swift
//  Presentation
//
//  Created by Junho Lee on 2023/01/12.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import DSKit
import SafariServices
import Combine

import Core

import BaseFeatureDependency
import AppMyPageFeatureInterface

public class WithdrawalVC: UIViewController, WithdrawalViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: WithdrawalViewModel!
    private let cancelBag = CancelBag()
    public var userType: UserType = .active
    
    // MARK: - WithdrawalViewCoordiatable
    
    public var onWithdrawal: (() -> Void)?
    
    // MARK: - UI Components

    private lazy var naviBar = OPNavigationBar(
            self,
            type: .oneLeftButton,
            backgroundColor: DSKitAsset.Colors.black100.color
        )
        .addMiddleLabel(title: I18N.Setting.Withdrawal.withdrawal)
    
    private let cautionLabel = UILabel().then {
        $0.text = I18N.Setting.Withdrawal.caution
        $0.textColor = DSKitAsset.Colors.white100.color
        $0.textAlignment = .left
        $0.numberOfLines = 3
        $0.setTypoStyle(DSKitFontFamily.Suit.bold.font(size: 16))
        $0.setLineSpacing(lineSpacing: 10)
    }
    
    private let guideLabel = UILabel().then {
        $0.text = I18N.Setting.Withdrawal.guide1
        $0.textColor = DSKitAsset.Colors.gray60.color
        $0.textAlignment = .left
        $0.setTypoStyle(DSKitFontFamily.Suit.regular.font(size: 14))
        $0.setLineSpacing(lineSpacing: 10)
    }
    
    private let secondGuideLabel = UILabel().then {
        $0.text = I18N.Setting.Withdrawal.guide2
        $0.textColor = DSKitAsset.Colors.gray60.color
        $0.textAlignment = .left
        $0.numberOfLines = 2
        $0.setTypoStyle(DSKitFontFamily.Suit.regular.font(size: 14))
        $0.setLineSpacing(lineSpacing: 10)
    }
    
    private lazy var withdrawalButton = AppCustomButton(title: I18N.Setting.Withdrawal.withdrawal)
        .setEnabled(true)
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.bindViewModels()
    }
}

// MARK: - UI & Layout

extension WithdrawalVC {
    
    private func setUI() {
        self.view.backgroundColor = DSKitAsset.Colors.black100.color
    }
    
    private func setLayout() {
        self.view.addSubviews(naviBar, cautionLabel, guideLabel, secondGuideLabel, withdrawalButton)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        cautionLabel.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
        }
        
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(cautionLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        secondGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        withdrawalButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(56.adjusted)
            make.width.equalTo(335.adjusted)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: - Methods

extension WithdrawalVC {
    
    private func bindViewModels() {
        
        let withdrawalButtonTapped = self.withdrawalButton
            .publisher(for: .touchUpInside)
            .withUnretained(self)
            .mapVoid()
            .asDriver()
        
        let input = WithdrawalViewModel.Input(withdrawalButtonTapped: withdrawalButtonTapped)
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.withdrawalSuccessed
            .withUnretained(self)
            .sink { owner, isSuccessed in
                if isSuccessed {
                    owner.showToastAndChangeRootView()
                } else {
                    owner.showNetworkAlert()
                }
            }.store(in: self.cancelBag)
    }
    
    private func showToastAndChangeRootView() {
        SFSafariViewController.DataStore.default.clearWebsiteData()
        onWithdrawal?()
    }
    
    public func showNetworkAlert() {
        AlertUtils.presentNetworkAlertVC(
            theme: .main,
            animated: true
        )
    }
}
