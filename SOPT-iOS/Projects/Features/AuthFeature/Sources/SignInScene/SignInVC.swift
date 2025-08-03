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
    
    private let loginHelpButton = UIButton(type: .system).then {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = DSKitAsset.Colors.gray30.color
        config.baseBackgroundColor = .clear
        
        var attributedTitle = AttributedString(i18n.helpLogin)
        attributedTitle.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
        config.attributedTitle = attributedTitle
        
        config.image = DSKitAsset.Assets.chevronRight.image.withTintColor(DSKitAsset.Colors.gray30.color).withRenderingMode(.alwaysTemplate)
        config.imagePadding = 0
        config.imagePlacement = .trailing
        
        $0.configuration = config
        $0.alpha = 0
    }
    
    private let leftLine = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray300.color
    }
    
    private let rightLine = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray300.color
    }
    
    private let orLabel = UILabel().then {
        $0.text = i18n.or
        $0.font = DSKitFontFamily.Suit.regular.font(size: 13)
    }
    
    private lazy var orStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 8
        $0.alpha = 0
    }
    
    private lazy var signUpButton = UIButton(type: .system).then {
        $0.setTitle(Self.i18n.signUp, for: .normal)
        $0.setTitleColor(DSKitAsset.Colors.white.color, for: .normal)
        $0.setBackgroundColor(DSKitAsset.Colors.gray700.color, for: .normal)
        $0.setBackgroundColor(DSKitAsset.Colors.gray800.color, for: .highlighted)
        $0.titleLabel?.font = DSKitFontFamily.Suit.semiBold.font(size: 16)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.alpha = 0
    }
    
    
    private let loginLaterButton = UIButton(type: .system).then {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = DSKitAsset.Colors.gray30.color
        config.baseBackgroundColor = .clear
        
        var attributedTitle = AttributedString(i18n.loginLater)
        attributedTitle.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
        config.attributedTitle = attributedTitle
        
        config.image = DSKitAsset.Assets.chevronRight.image.withTintColor(DSKitAsset.Colors.gray30.color)
        config.imagePadding = 0
        config.imagePlacement = .trailing
        
        $0.configuration = config
        $0.alpha = 0
    }
    
    private let recentLoginLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.medium.font(size: 13)
        $0.textColor = DSKitAsset.Colors.gray50.color
    }
    
    private lazy var recentLoginToolTip = ToolTipView().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = DSKitAsset.Colors.success.color
        
        $0.contentView.addSubview(recentLoginLabel)
        
        recentLoginLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        $0.alpha = 0
    }
    
    
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
        self.bindViewModels()
        self.setUI()
        self.setLayout()
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
        self.view.backgroundColor = DSKitAsset.Colors.soptampBlack.color
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
        
        orStackView.addArrangedSubviews(leftLine, orLabel, rightLine)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Metric.topInset)
            make.centerX.equalToSuperview()
            make.width.equalTo(Metric.logoWidth)
            make.height.equalTo(Metric.logoWidth).multipliedBy(Metric.logoRatio)
        }
        
        oAuthView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(loginHelpButton.snp.top).offset(-20.adjustedH)
        }
        
        loginHelpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(20.adjustedH)
            make.bottom.equalTo(orStackView.snp.top).offset(-44.adjustedH)
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
            make.bottom.equalTo(signUpButton.snp.top).inset(-16.adjustedH)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
            make.bottom.equalTo(loginLaterButton.snp.top).offset(-16.adjustedH)
        }
        
        loginLaterButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(28.adjustedH)
        }
        
        recentLoginToolTip.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(oAuthView.googleLoginButton.snp.top)
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
                
                owner.recentLoginLabel.text = "로그인한 계정은 \(oAuthProvider.title)이에요."
                
                let bottomAnchor: ConstraintRelatableTarget = oAuthProvider == .apple ? owner.oAuthView.appleLoginButton.snp.top : owner.oAuthView.googleLoginButton.snp.top
                
                owner.recentLoginToolTip.snp.updateConstraints {
                    $0.bottom.equalTo(bottomAnchor).offset(-19)
                }
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
