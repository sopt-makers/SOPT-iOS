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
    
    private let phoneVerifyView = PhoneVerifyView()
    private let oAuthView = SignUpOAuthView()
    
    private let viewModel: SignUpViewModel
    private let phoneVerifyViewModel: PhoneVerifyViewModel
    
    private let cancelBag = CancelBag()
    
    // MARK: - Initialization
    
    init(
        viewModel: SignUpViewModel,
        phoneVerifyViewModel: PhoneVerifyViewModel
    ) {
        self.viewModel = viewModel
        self.phoneVerifyViewModel = phoneVerifyViewModel
        
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
    
    private let checkImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.check.image.withAlignmentRectInsets(.init(top: -4, left: -4, bottom: -4, right: -4))
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = DSKitAsset.Colors.blue400.color
        $0.layer.cornerRadius = 11
        $0.layer.masksToBounds = true
        $0.isHidden = true
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
        self.view.backgroundColor = DSKitAsset.Colors.black100.color
        
        self.view.addSubviews(
            navigationBar,
            lineView,
            firstCircle,
            checkImageView,
            secondCircle,
            firstLabel,
            secondLabel,
            phoneVerifyView,
            oAuthView
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
        
        checkImageView.snp.makeConstraints {
            $0.edges.equalTo(firstCircle)
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
        
        oAuthView.snp.makeConstraints {
            $0.edges.equalTo(phoneVerifyView)
        }
        
    }
    
    private func bind() {

        let pvInput = phoneVerifyView.viewModelInput
        let pvOutput = phoneVerifyViewModel.transform(from: pvInput, cancelBag: cancelBag)
        phoneVerifyView.bindOutput(pvOutput, cancelBag: cancelBag)
            
        let input = type(of: viewModel).Input.init(
            phone: pvOutput.phoneTextFieldText.asDriver(),
            verifySuccess: pvOutput.verifySuccess.asDriver(),
            loginHelpButtonTapped: phoneVerifyView.loginHelpButtonTapped,
            oAuth: oAuthView.viewModelInput
        )
        
        let output = viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.currentStep
            .withUnretained(self)
            .sink { owner, step in
                let bg = step == .phoneVerify ? DSKitAsset.Colors.black40.color : DSKitAsset.Colors.blue400.color
                owner.phoneVerifyView.isHidden = step != .phoneVerify
                owner.oAuthView.isHidden = step != .oAuth
                owner.checkImageView.isHidden = step == .phoneVerify
                owner.lineView.backgroundColor = bg
                owner.secondCircle.backgroundColor = bg
                owner.navigationBar.isHidden = step != .phoneVerify
            }
            .store(in: cancelBag)
        
        output.signUpSucceed
            .withUnretained(self)
            .sink { owner, _ in
                Toast.showMDSToast(type: .success, text: "회원가입에 성공했습니다.")
            }.store(in: cancelBag)
    }
    
}
