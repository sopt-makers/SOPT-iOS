//
//  WithdrawalVC.swift
//  Presentation
//
//  Created by Junho Lee on 2023/01/12.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import DSKit

import Core

import AuthFeatureInterface
import SettingFeatureInterface
import StampFeatureInterface

public class WithdrawalVC: UIViewController, WithdrawalViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: WithdrawalViewModel!
    public var factory: (AuthFeatureViewBuildable & StampFeatureViewBuildable)!
    private let cancelBag = CancelBag()
    
    // MARK: - UI Components

    private lazy var naviBar = CustomNavigationBar(self, type: .titleWithLeftButton)
        .setTitle(I18N.Setting.Withdrawal.withdrawal)
    
    private let cautionLabel = UILabel().then {
        $0.text = I18N.Setting.Withdrawal.caution
        $0.textColor = DSKitAsset.Colors.gray900.color
        $0.textAlignment = .left
        $0.numberOfLines = 3
        $0.setTypoStyle(.SoptampFont.subtitle1)
        $0.setLineSpacing(lineSpacing: 10)
    }
    
    private let guideLabel = UILabel().then {
        $0.text = I18N.Setting.Withdrawal.guide1
        $0.textColor = DSKitAsset.Colors.gray600.color
        $0.textAlignment = .left
        $0.setTypoStyle(.SoptampFont.caption1)
        $0.setLineSpacing(lineSpacing: 10)
    }
    
    private let secondGuideLabel = UILabel().then {
        $0.text = I18N.Setting.Withdrawal.guide2
        $0.textColor = DSKitAsset.Colors.gray600.color
        $0.textAlignment = .left
        $0.numberOfLines = 2
        $0.setTypoStyle(.SoptampFont.caption1)
        $0.setLineSpacing(lineSpacing: 10)
    }
    
    private lazy var withdrawalButton = UIButton(type: .system).then {
        $0.setTitle(I18N.Setting.Withdrawal.withdrawal, for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.setTypoStyle(.SoptampFont.h2)
        $0.layer.cornerRadius = 9
        $0.backgroundColor = DSKitAsset.Colors.purple300.color
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
        self.view.backgroundColor = .white
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
            make.top.equalTo(secondGuideLabel.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.height.equalTo(56.adjusted)
            make.width.equalTo(335.adjusted)
        }
    }
}

// MARK: - Methods

extension WithdrawalVC {
    
    private func bindViewModels() {
        
        let withdrawalButtonTapped = self.withdrawalButton
            .publisher(for: .touchUpInside)
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
        let window = self.view.window!
        let navigation = UINavigationController(rootViewController: factory.makeSignInVC().viewController)
        navigation.isNavigationBarHidden = true
        ViewControllerUtils.setRootViewController(window: self.view.window!, viewController: navigation, withAnimation: true) { newWindow in
            Toast.show(message: I18N.Setting.Withdrawal.withdrawalSuccess,
                       view: newWindow,
                       safeAreaBottomInset: self.safeAreaBottomInset())
        }
    }
    
    public func showNetworkAlert() {
        let alertVC = factory.makeNetworkAlertVC().viewController
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        self.present(alertVC, animated: true)
    }
}
