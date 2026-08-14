//
//  SignInVC.swift
//  Presentation
//
//  Created by devxsby on 2022/12/01.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import Combine
import SafariServices

import DSKit
import Core
import Domain
import MDS

import AuthFeatureInterface
import BaseFeatureDependency

import SnapKit
import Then

public class SignInVC: UIViewController, SignInViewControllable {
    
    // MARK: - Properties
    
    private static let i18n = I18N.SignIn.Refactor.self
    
    public var viewModel: SignInViewModel
    
    private var cancelBag = CancelBag()
    
    private var viewWillAppear = PassthroughSubject<Void, Never>()
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    
    private let containerView = UIView()
    
    private let logoImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.imgLogoBig.image
        $0.contentMode = .scaleAspectFit
    }
    
    private let oAuthView = OAuthView().then {
        $0.alpha = 0
    }
    
    private let loginHelpButton = MDSTextButton(variant: .emphasis, size: .medium, title: i18n.helpLogin, icon: .chevronRightOutlined).then {
        $0.alpha = 0
    }

    private let leftLine = UIView().then {
        $0.backgroundColor = SemanticColor.Stroke.Neutral.subtle
    }

    private let rightLine = UIView().then {
        $0.backgroundColor = SemanticColor.Stroke.Neutral.subtle
    }

    private let orLabel = UILabel().then {
        $0.text = i18n.or
        $0.setTypography(Typography.label4, textColor: SemanticColor.Fg.Neutral.ghost)
    }

    private lazy var orStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = BaseSpacing.Base.s8
        $0.alpha = 0
    }

    private lazy var signUpButton = MDSActionButton(variant: .secondary, size: .medium, title: Self.i18n.signUp).then {
        $0.alpha = 0
    }


    private let loginLaterButton = MDSTextButton(variant: .emphasis, size: .medium, title: i18n.loginLater, icon: .chevronRightOutlined).then {
        $0.alpha = 0
    }

    private let recentLoginLabel = UILabel().then {
        $0.setTypography(Typography.body3, textColor: SemanticColor.Fg.Neutral.bold)
    }

    private let recentLoginToolTip = ToolTipView()
    
    
    // MARK: - View Life Cycle
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.view.layoutIfNeeded()
        self.bindViewModels()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        viewWillAppear.send(())
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performAnimation()
    }
    
    // MARK: - UI & Layout
    
    private enum Metric {
        static let topInset = 151.adjustedH + logoMutableY
        static let logoWidth = 184.adjusted
        static let logoMutableY = 137.adjustedH
        static let logoRatio = 114 / 184
    }
    
    private func setUI() {
        self.view.backgroundColor = SemanticColor.Bg.Layer.basement

        self.recentLoginToolTip.layer.cornerRadius = BaseRadius.Base.r12
        self.recentLoginToolTip.backgroundColor = SemanticColor.Bg.Secondary.default
        self.recentLoginToolTip.contentView.addSubview(recentLoginLabel)
        self.recentLoginToolTip.alpha = 0
    }
    
    private func setLayout() {
        self.view.addSubviews(
            logoImageView,
            oAuthView,
            loginHelpButton,
            orStackView,
            signUpButton,
            loginLaterButton,
            recentLoginToolTip
        )
        
        recentLoginToolTip.addSubview(recentLoginLabel)
        
        recentLoginLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(BaseSpacing.Base.s10)
            $0.horizontalEdges.equalToSuperview().inset(BaseSpacing.Base.s20)
        }
        
        orStackView.addArrangedSubviews(leftLine, orLabel, rightLine)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Metric.topInset)
            make.centerX.equalToSuperview()
            make.width.equalTo(Metric.logoWidth)
            make.height.equalTo(Metric.logoWidth).multipliedBy(Metric.logoRatio)
        }
        
        oAuthView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(loginHelpButton.snp.top).offset(-BaseSpacing.Base.s24)
        }

        loginHelpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(orStackView.snp.top).offset(-BaseSpacing.Base.s40)
        }
        
        leftLine.setContentHuggingPriority(.defaultLow, for: .horizontal)
        leftLine.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        rightLine.setContentHuggingPriority(.defaultLow, for: .horizontal)
        rightLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(leftLine)
        }
        
        orLabel.setContentHuggingPriority(.required, for: .horizontal)
        orLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        orStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(signUpButton.snp.top).inset(-BaseSpacing.Base.s16)
        }

        signUpButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(loginLaterButton.snp.top).offset(-BaseSpacing.Base.s24)
        }
        
        loginLaterButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40.adjustedH)
        }
        
        recentLoginToolTip.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(oAuthView.googleLoginButton.snp.top).offset(-19)
        }
    }
    
    private func performAnimation() {
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
            self.updateLogoY()
        })
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.retrieveAlpha()
        })
    }
    
    private func updateLogoY() {
        logoImageView.transform = CGAffineTransform(translationX: 0, y: -Metric.logoMutableY)
    }
    
    private func retrieveAlpha() {
        [oAuthView, loginHelpButton, orStackView, signUpButton, loginLaterButton, recentLoginToolTip].forEach {
            $0.alpha = 1
        }
    }
}

// MARK: - Methods

extension SignInVC {
    
    private func bindViewModels() {
        
        let input = SignInViewModel.Input(
            viewDidLoad: Just<Void>(()).asDriver(),
            viewWillAppear: self.viewWillAppear.asDriver(),
            googleLoginButtonTapped:
                oAuthView.googleLoginButton
                .publisher(for: .touchUpInside)
                .compactMap { _ in () }
                .asDriver(),
            appleLoginButtonTapped:
                oAuthView.appleLoginButton
                .publisher(for: .touchUpInside)
                .compactMap { _ in () }
                .asDriver(),
            loginHelpButtonTapped: self.loginHelpButton
                .publisher(for: .touchUpInside)
                .compactMap { _ in () }
                .asDriver(),
            visitorButtonTapped: self.loginLaterButton
                .publisher(for: .touchUpInside)
                .compactMap { _ in () }
                .asDriver(),
            signUpButtonTapped: self.signUpButton
                .publisher(for: .touchUpInside)
                .compactMap { _ in () }
                .asDriver()
        )
        let output = self.viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.recentLogin
            .withUnretained(self)
            .sink { owner, oAuthProvider in
                owner.recentLoginToolTip.isHidden = oAuthProvider == nil
                
                guard let oAuthProvider else { return }

                owner.recentLoginLabel.text = "최근 로그인한 계정은 \(oAuthProvider.title)이에요."
                owner.recentLoginLabel.setTypography(Typography.body3, textColor: SemanticColor.Fg.Neutral.bold)
            }
            .store(in: cancelBag)
        
        output.loginFailToastMessage
            .withUnretained(self)
            .sink { owner, message in
                Toast.showMDSToast(type: .error, text: message)
            }
            .store(in: cancelBag)
    }
}
