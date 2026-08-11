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
import MDS

import AuthFeatureInterface
import BaseFeatureDependency

import SnapKit
import Then

public class SignUpVC: UIViewController, SignUpViewControllable {
    
    //MARK: - Properties
    
    private let phoneVerifyView = PhoneVerifyView()         // SOPT 회원인증
    private let oAuthView = SignUpOAuthView()               // 소셜 계정연동
    
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
        backgroundColor: SemanticColor.Bg.Layer.basement,
        ignoreLeftButtonAction: false
    )

    private let lineView = UIView().then {
        $0.backgroundColor = SemanticColor.Bg.Neutral.default
    }

    private let firstStepIndicator = StepIndicatorView(
        number: "1",
        title: I18N.Auth.PhoneVerify.title,
        circleTextColor: SemanticColor.Fg.Neutral.bold,
        circleBackgroundColor: SemanticColor.Bg.Secondary.default,
        titleTextColor: SemanticColor.Fg.Neutral.bold
    )

    private let secondStepIndicator = StepIndicatorView(
        number: "2",
        title: I18N.Auth.SocialLink.title,
        circleTextColor: SemanticColor.Fg.Neutral.ghost,
        circleBackgroundColor: SemanticColor.Bg.Neutral.default,
        titleTextColor: SemanticColor.Fg.Neutral.ghost
    )

    private let checkImageView = UIImageView().then {
        $0.image = MDSIcon.checkOutlined.image.withRenderingMode(.alwaysTemplate).withAlignmentRectInsets(.init(top: -4, left: -4, bottom: -4, right: -4))
        $0.tintColor = SemanticColor.Fg.Neutral.bold
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = SemanticColor.Bg.Secondary.default
        $0.layer.cornerRadius = BaseRadius.Base.full
        $0.layer.masksToBounds = true
        $0.isHidden = true
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
        self.view.backgroundColor = SemanticColor.Bg.Layer.basement

        self.view.addSubviews(
            navigationBar,
            lineView,
            firstStepIndicator,
            checkImageView,
            secondStepIndicator,
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
            $0.top.equalTo(navigationBar.snp.bottom).offset(35)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(136)
            $0.height.equalTo(1)
        }
        
        firstStepIndicator.snp.makeConstraints {
            $0.centerX.equalTo(lineView.snp.leading)
            $0.top.equalTo(lineView.snp.centerY).offset(-11)
        }

        checkImageView.snp.makeConstraints {
            $0.edges.equalTo(firstStepIndicator.circleView)
        }

        secondStepIndicator.snp.makeConstraints {
            $0.centerX.equalTo(lineView.snp.trailing)
            $0.top.equalTo(lineView.snp.centerY).offset(-11)
        }

        phoneVerifyView.snp.makeConstraints {
            $0.top.equalTo(firstStepIndicator.titleLabel.snp.bottom).offset(32)
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
                let bg = step == .phoneVerify ? SemanticColor.Bg.Neutral.default : SemanticColor.Bg.Secondary.default
                owner.phoneVerifyView.isHidden = step != .phoneVerify
                owner.oAuthView.isHidden = step != .oAuth
                owner.checkImageView.isHidden = step == .phoneVerify
                owner.lineView.backgroundColor = bg
                owner.secondStepIndicator.setCircleBackgroundColor(bg)
                owner.navigationBar.isHidden = step != .phoneVerify

                owner.firstStepIndicator.setTitleActive(step == .phoneVerify)
                owner.secondStepIndicator.setTitleActive(step != .phoneVerify)
            }
            .store(in: cancelBag)
        
        output.signUpSucceed
            .withUnretained(self)
            .sink { owner, _ in
                Toast.showMDSToast(type: .success, text: "회원가입에 성공했습니다.")
            }.store(in: cancelBag)
    }
}
