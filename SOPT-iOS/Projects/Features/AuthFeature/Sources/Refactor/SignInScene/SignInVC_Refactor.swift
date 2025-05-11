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

public class SignInVC_Refactor: UIViewController, SignInViewControllable {
    
    // MARK: - Properties
    
    private static let i18n = I18N.SignIn.Refactor.self
    public var viewModel: SignInViewModel_Refactor!
    public var skipAnimation: Bool = false
    public var accessCode: String? = nil
    public var requestState: String? = nil
    private var cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    
    private let containerView = UIView()
    
    private let logoImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.imgLogoBig.image
        $0.contentMode = .scaleAspectFit
    }
    
    private let googleLoginButton = AppImageTextButton(
        title: i18n.googleLogin,
        image: DSKitAsset.Assets.logoGoogle.image.withRenderingMode(.automatic)
    ).then {
        $0.alpha = 0
    }
    
    private let appleLoginButton = AppImageTextButton(
        title: i18n.appleLogin,
        image: DSKitAsset.Assets.logoApple.image
    ).then {
        $0.alpha = 0
    }
    
    //TODO: 인증중앙화 완료 시 제거
    private let playgroundButton = AppImageTextButton(title: i18n.playgroundLogin).then { $0.alpha = 0 }
    
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
        $0.setTitleColor(DSKitAsset.Colors.white100.color, for: .normal)
        $0.setBackgroundColor(DSKitAsset.Colors.gray700.color, for: .normal)
        $0.setBackgroundColor(DSKitAsset.Colors.gray800.color, for: .highlighted)
        $0.titleLabel?.setTypoStyle(DSKitFontFamily.Suit.semiBold.font(size: 16))
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
    
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
        self.bindViews()
        self.setUI()
        self.setLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performAnimation()
    }
}

// MARK: - UI & Layout

extension SignInVC_Refactor {
    
    private enum Metric {
        static let topInset = 100.adjustedH + logoMutableY //151.adjustedH + logoMutableY
        static let logoWidth = 184.adjusted
        static let logoMutableY = 188.adjustedH // 137.adjustedH
        static let logoRatio = 114 / 184
    }
    
    private func setUI() {
        self.view.backgroundColor = DSKitAsset.Colors.soptampBlack.color
    }
    
    private func setLayout() {
        self.view.addSubviews(
            logoImageView,
            googleLoginButton,
            appleLoginButton,
            playgroundButton,
            loginHelpButton,
            orStackView,
            signUpButton,
            loginLaterButton
        )
        
        orStackView.addArrangedSubviews(leftLine, orLabel, rightLine)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Metric.topInset)
            make.centerX.equalToSuperview()
            make.width.equalTo(Metric.logoWidth)
            make.height.equalTo(Metric.logoWidth).multipliedBy(Metric.logoRatio)
        }
        
        googleLoginButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
            make.bottom.equalTo(appleLoginButton.snp.top).offset(-20.adjustedH)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
            make.bottom.equalTo(playgroundButton.snp.top).offset(-20.adjustedH)
        }
        
        playgroundButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
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
    }
    
    private func performAnimation() {
        guard !skipAnimation else {
            retrieveAlpha()
            updateLogoY()
            return
        }
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
        [googleLoginButton, appleLoginButton, playgroundButton, loginHelpButton, orStackView, signUpButton, loginLaterButton].forEach {
            $0.alpha = 1
        }
    }
}

// MARK: - Methods

extension SignInVC_Refactor {
    
    private func bindViews() {
        playgroundButton.publisher(for: .touchUpInside)
            .withUnretained(self)
            .asDriver()
            .sink { owner, _ in
                owner.openPlaygroundURL()
            }.store(in: self.cancelBag)
    }
    
    private func bindViewModels() {
        
        let input = SignInViewModel_Refactor.Input(
                    viewDidLoad: Just<Void>(()).asDriver(),
                    googleLoginButtonTapped:
                        self.googleLoginButton
                        .publisher(for: .touchUpInside)
                        .compactMap { _ in () }
                        .asDriver(),
                    appleLoginButtonTapped:
                        self.appleLoginButton
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
        let _ = self.viewModel.transform(from: input, cancelBag: cancelBag)
    }
    
    private func openPlaygroundURL() {
        let state = UUID().uuidString
        UserDefaultKeyList.Auth.requestState = state
        guard let url = URL(string: ExternalURL.Playground.login(state: state)) else {
            print("⚠️Invalid URL String at openPlaygroundURL: \(ExternalURL.Playground.login(state: state))")
            makeAlert(title: "URL 에러", message: "잘못된 URL이 생성되었습니다. 개발자에게 문의주시면 감사하겠습니다.")
            return
        }
        let safari = SFSafariViewController(url: url)
        safari.modalPresentationStyle = .fullScreen
        safari.playgroundStyle()
        self.present(safari, animated: true)
    }
}
