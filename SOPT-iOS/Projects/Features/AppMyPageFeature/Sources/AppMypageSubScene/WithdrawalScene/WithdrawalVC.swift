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

public class WithdrawalVC: UIViewController, LegacyWithdrawalViewControllable {
    
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
    
    
    private let noticeCardView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray800.color
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    private let warningIconImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.caution.image
        $0.tintColor = DSKitAsset.Colors.error.color
        $0.contentMode = .scaleAspectFit
    }
    
    private let cautionLabel = UILabel().then {
        $0.text = I18N.Setting.Withdrawal.caution
        $0.textColor = DSKitAsset.Colors.gray50.color
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 18)
    }
    
    private let guideLabel = UILabel().then {
        $0.text = I18N.Setting.Withdrawal.guide1
        $0.textColor = DSKitAsset.Colors.gray60.color
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.font = DSKitFontFamily.Suit.regular.font(size: 14)
    }
    
    private let secondGuideLabel = UILabel().then {
        $0.text = I18N.Setting.Withdrawal.guide2
        $0.textColor = DSKitAsset.Colors.gray60.color
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.font = DSKitFontFamily.Suit.regular.font(size: 14)
    }
    
    private lazy var withdrawalButton = AppCustomButton(title: I18N.Setting.Withdrawal.withdrawal)
        .setEnabled(true)
        .setConfigForState(enabledTextColor: DSKitAsset.Colors.error.color)
    
    init(viewModel: WithdrawalViewModel!, userType: UserType, onWithdrawal: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.userType = userType
        self.onWithdrawal = onWithdrawal
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

// MARK: - UI & Layout

extension WithdrawalVC {
    
    private func setUI() {
        self.view.backgroundColor = DSKitAsset.Colors.black100.color
    }
    
    private func setLayout() {
        self.view.addSubviews(naviBar, noticeCardView, withdrawalButton)
        self.noticeCardView.addSubviews(warningIconImageView, cautionLabel, guideLabel, secondGuideLabel)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        noticeCardView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        warningIconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.centerX.equalToSuperview()
            make.size.equalTo(64)
        }
        
        cautionLabel.snp.makeConstraints { make in
            make.top.equalTo(warningIconImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(cautionLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        secondGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
        }
        
        withdrawalButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.horizontalEdges.equalToSuperview().inset(20)
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
