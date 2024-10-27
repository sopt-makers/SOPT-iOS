//
//  LoginHelpBottomSheetVC.swift
//  AuthFeature
//
//  Created by 장석우 on 10/23/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import BaseFeatureDependency
import Core
import DSKit
import Domain

public final class LoginHelpBottomSheetVC: UIViewController, LoginHelpBottomSheetViewControllable {
    
    public var onWantToKnowLoginAccountButtonDidTap: (() -> Void)?
    public var onResetSocialAccountButtonDidTap: (() -> Void)?
    private let cancelBag = CancelBag()
    
    public var minimumContentHeight: CGFloat {
        return 158.f
    }
    
    // MARK: - Views
    
    private let warnImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.alertCircle.image
    }
    
    private let titleLabel = UILabel().then {
        $0.text = I18N.SignIn.helpLogin
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 20)
        $0.textColor = DSKitAsset.Colors.gray10.color
    }
    
    private let wantToKnowAccountButton = UIButton().then {
        $0.setTitleColor(DSKitAsset.Colors.gray10.color, for: .normal)
        $0.setTitle(I18N.SignIn.wantToKnowAccount, for: .normal)
        $0.contentHorizontalAlignment = .leading
        $0.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        $0.titleLabel?.font = DSKitFontFamily.Suit.regular.font(size: 16)
        $0.setBackgroundColor(DSKitAsset.Colors.gray700.color, for: .highlighted)
        $0.setBackgroundColor(DSKitAsset.Colors.gray800.color, for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    private let resetSocialAccountButton = UIButton().then {
        $0.setTitleColor(DSKitAsset.Colors.gray10.color, for: .normal)
        $0.setTitle(I18N.SignIn.resetSocialAccount, for: .normal)
        $0.titleLabel?.font = DSKitFontFamily.Suit.regular.font(size: 16)
        $0.contentHorizontalAlignment = .leading
        $0.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        $0.setBackgroundColor(DSKitAsset.Colors.gray700.color, for: .highlighted)
        $0.setBackgroundColor(DSKitAsset.Colors.gray800.color, for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = DSKitAsset.Colors.gray800.color
        
        self.setLayout()
        self.bindAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginHelpBottomSheetVC {
    
    private func setLayout() {
        
        self.view.addSubviews(
            warnImageView,
            titleLabel,
            wantToKnowAccountButton,
            resetSocialAccountButton
        )
        
        self.warnImageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.equalToSuperview().inset(20)
            
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(warnImageView)
            $0.leading.equalTo(warnImageView.snp.trailing).offset(4)
        }
        
        self.wantToKnowAccountButton.snp.makeConstraints {
            $0.top.equalTo(warnImageView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(14)
            $0.height.equalTo(44.adjustedH)
        }
        
        self.resetSocialAccountButton.snp.makeConstraints {
            $0.top.equalTo(wantToKnowAccountButton.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(14)
            $0.height.equalTo(44.adjustedH)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    }
    
    
    private func bindAction() {
        wantToKnowAccountButton
            .publisher(for: .touchUpInside)
            .asDriver()
            .withUnretained(self)
            .sink { owner, _ in
                owner.onWantToKnowLoginAccountButtonDidTap?()
            }
            .store(in: cancelBag)
        
        resetSocialAccountButton
            .publisher(for: .touchUpInside)
            .asDriver()
            .withUnretained(self)
            .sink { owner, _ in
                owner.onResetSocialAccountButtonDidTap?()
            }
            .store(in: cancelBag)
    }
}

