//
//  SignUpOAuthView.swift
//  AuthFeature
//
//  Created by 장석우 on 1/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class SignUpOAuthView: UIView {
    
    public var viewModelInput: SignUpViewModel.Input.OAuth {
        .init(
            googleLoginTapped: googleLoginButton.publisher(for: .touchUpInside).mapVoid().asDriver(),
            appleLoginTapped: appleLoginButton.publisher(for: .touchUpInside).mapVoid().asDriver()
        )
    }
    
    //MARK: - Properties

    private let titleLabel = UILabel().then {
        $0.text = "소셜 계정 연동"
        $0.font = DSKitFontFamily.Suit.bold.font(size: 24)
        $0.textColor = DSKitAsset.Colors.gray10.color
        $0.textAlignment = .center
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "반갑습니다 회원님\n소셜로그인을 진행하여 회원가입을 완료해주세요"
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 12)
        $0.textColor = DSKitAsset.Colors.gray60.color
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    private let googleLoginButton = AppImageTextButton(
        title: I18N.SignIn.googleLogin,
        image: DSKitAsset.Assets.logoGoogle.image.withRenderingMode(.automatic)
    )
    
    private let appleLoginButton = AppImageTextButton(
        title: I18N.SignIn.appleLogin,
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
