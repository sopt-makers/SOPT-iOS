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

class SignUpOAuthView: UIView {
    
    var viewModelInput: SignUpViewModel.Input.OAuth {
        .init(googleLoginTapped: .empty(), appleLoginTapped: .empty())
    }
    
    //MARK: - Properties
    
    private let lineView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.black40.color
    }
    
    private let firstCircle = UILabel().then {
        $0.text = "1"
        $0.font = DSKitFontFamily.Suit.bold.font(size: 12)
        $0.backgroundColor = DSKitAsset.Colors.blue400.color
        $0.layer.cornerRadius = 11
        $0.layer.masksToBounds = true
        $0.textAlignment = .center
    }
    
    private let secondCircle = UILabel().then {
        $0.text = "2"
        $0.font = DSKitFontFamily.Suit.bold.font(size: 12)
        $0.backgroundColor = DSKitAsset.Colors.black40.color
        $0.layer.cornerRadius = 11
        $0.layer.masksToBounds = true
        $0.textAlignment = .center
    }
    
    private let firstLabel = UILabel().then {
        $0.text = "SOPT 회원인증"
        $0.font = DSKitFontFamily.Suit.bold.font(size: 12)
        $0.textColor = DSKitAsset.Colors.white.color
        $0.textAlignment = .center
    }
    
    private let secondLabel = UILabel().then {
        $0.text = "소셜 계정 연동"
        $0.font = DSKitFontFamily.Suit.bold.font(size: 12)
        $0.textColor = DSKitAsset.Colors.white.color
        $0.textAlignment = .center
    }
    
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
        self.addSubviews(
            lineView,
            firstCircle,
            secondCircle,
            firstLabel,
            secondLabel,
            titleLabel,
            descriptionLabel,
            googleLoginButton,
            appleLoginButton
        )
    }
    
    private func setLayout() {
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(28)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(123)
            $0.height.equalTo(1)
        }
        
        firstCircle.snp.makeConstraints {
            $0.centerX.equalTo(lineView.snp.leading)
            $0.centerY.equalTo(lineView)
            $0.size.equalTo(22)
        }
        
        secondCircle.snp.makeConstraints {
            $0.centerX.equalTo(lineView.snp.trailing)
            $0.centerY.equalTo(lineView)
            $0.size.equalTo(22)
        }
        
        firstLabel.snp.makeConstraints {
            $0.top.equalTo(firstCircle.snp.bottom).offset(12)
            $0.centerX.equalTo(firstCircle)
        }
        
        secondLabel.snp.makeConstraints {
            $0.top.equalTo(secondCircle.snp.bottom).offset(12)
            $0.centerX.equalTo(secondCircle)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(firstLabel.snp.bottom).offset(54)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
        }
       
    }
}

extension SignUpOAuthView {
    func bindOutput(_ output: SignUpViewModel.Output.OAuth, cancelBag: CancelBag) {
        
    }
}
