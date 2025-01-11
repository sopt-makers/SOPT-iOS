//
//  SignUpPhoneVerificationVC.swift
//  AuthFeature
//
//  Created by 장석우 on 12/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import DSKit
import Core

import AuthFeatureInterface
import BaseFeatureDependency

import SnapKit
import Then

public class SignUpVC: UIViewController, SignUpViewControllable {
    
    //MARK: - Properties
    
    private let phoneVerifyView = SignUpPhoneVerifyView()
    private let oAuthView = SignUpOAuthView()
    
    private let viewModel: SignUpViewModel
    
    private let cancelBag = CancelBag()
    
    // MARK: - Initialization
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    private lazy var navigationBar = OPNavigationBar(
        self,
        type: .oneLeftButton,
        backgroundColor: DSKitAsset.Colors.black100.color,
        ignoreLeftButtonAction: false
    )
    
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
   
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        bind()
    }
    
}

// MARK: - UI & Layout

extension SignUpVC {
    
    private func setUI() {
        self.view.addSubviews(
            navigationBar,
            lineView,
            firstCircle,
            secondCircle,
            firstLabel,
            secondLabel,
            phoneVerifyView
        )
    }
    
    private func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
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
        
        phoneVerifyView.snp.makeConstraints {
            $0.top.equalTo(firstLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    private func bind() {
        let input = type(of: viewModel).Input.init(
            viewDidLoad: Just<Void>(()).asDriver(),
            phoneVerify: phoneVerifyView.viewModelInput,
            oauth: oAuthView.viewModelInput
        )
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        phoneVerifyView.bindOutput(output.phoneVerify, cancelBag: cancelBag)
        oAuthView.bindOutput(output.oauth, cancelBag: cancelBag)
    }
    
}
