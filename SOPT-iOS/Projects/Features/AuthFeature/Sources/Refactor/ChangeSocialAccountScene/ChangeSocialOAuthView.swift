//
//  ChangeSocialOAuthView.swift
//  AuthFeature
//
//  Created by 장석우 on 5/24/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

public final class ChangeSocialOAuthView: UIView {
    
    private static let i18n = I18N.SignIn.Refactor.self
    
    public var viewModelInput: ChangeSocialAccountViewModel.Input.OAuth {
        .init(
            googleLoginTapped: googleLoginButton.publisher(for: .touchUpInside).mapVoid().asDriver(),
            appleLoginTapped: appleLoginButton.publisher(for: .touchUpInside).mapVoid().asDriver()
        )
    }
    
    //MARK: - Properties

    private let titleLabel = UILabel().then {
        $0.text = "소셜 계정 재설정"
        $0.font = DSKitFontFamily.Suit.bold.font(size: 24)
        $0.textColor = DSKitAsset.Colors.gray10.color
        $0.textAlignment = .center
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "반갑습니다 회원님\n재설정할 소셜 계정을 선택해주세요"
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 12)
        $0.textColor = DSKitAsset.Colors.gray60.color
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    private let googleLoginButton = AppImageTextButton(
        title: i18n.googleLogin,
        image: DSKitAsset.Assets.logoGoogle.image.withRenderingMode(.automatic)
    )
    
    private let appleLoginButton = AppImageTextButton(
        title: i18n.googleLogin,
        image: DSKitAsset.Assets.logoApple.image
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.black100.color
    }
    
    private func setLayout() {
        self.addSubviews(
            titleLabel,
            descriptionLabel,
            googleLoginButton,
            appleLoginButton
        )
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(54)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
        }
        
        googleLoginButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
            
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(googleLoginButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
            $0.bottom.lessThanOrEqualToSuperview()
        }
       
    }
}
