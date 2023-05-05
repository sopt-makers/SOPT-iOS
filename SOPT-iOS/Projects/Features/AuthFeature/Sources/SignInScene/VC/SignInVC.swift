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
import MainFeatureInterface

import SnapKit
import Then
import Sentry

public class SignInVC: UIViewController, SignInViewControllable {
    
    // MARK: - Properties
    
    public var factory: (AuthFeatureViewBuildable & MainFeatureViewBuildable)!
    public var viewModel: SignInViewModel!
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
    
    private lazy var signInButton = STCustomButton(title: I18N.SignIn.signIn).then {
        $0.setColor(
            bgColor: DSKitAsset.Colors.purple100.color,
            disableColor: DSKitAsset.Colors.purple100.color
        )
        $0.alpha = 0
        $0.setAttributedTitle(
            NSAttributedString(
                string: I18N.SignIn.signIn,
                attributes: [.font: UIFont.Main.body1, .foregroundColor: UIColor.white]
            ),
            for: .normal
        )
    }
    
    private lazy var notMemberButton = UIButton(type: .system).then {
        $0.setTitle(I18N.SignIn.notMember, for: .normal)
        $0.setTitleColor(DSKitAsset.Colors.purple100.color, for: .normal)
        $0.titleLabel!.setTypoStyle(.SoptampFont.caption1)
        $0.alpha = 0
    }
    
    private let bottomLogoImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.imgBottomLogo.image
        $0.contentMode = .scaleAspectFit
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

extension SignInVC {
    
    private enum Metric {
        static let topInset = 151.adjustedH + logoMutableY
        static let logoWidth = 184.adjusted
        static let logoMutableY = 137.adjustedH
        static let logoRatio = 114 / 184
    }
    
    private func setUI() {
        self.view.backgroundColor = DSKitAsset.Colors.soptampBlack.color
        self.notMemberButton.setUnderline()
    }
    
    private func setLayout() {
        self.view.addSubviews(logoImageView, signInButton, notMemberButton,
                              bottomLogoImageView)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Metric.topInset)
            make.centerX.equalToSuperview()
            make.width.equalTo(Metric.logoWidth)
            make.height.equalTo(Metric.logoWidth).multipliedBy(Metric.logoRatio)
        }
        
        signInButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56.adjustedH)
            make.bottom.equalTo(notMemberButton.snp.top).offset(-20.adjustedH)
        }
        
        notMemberButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(20.adjustedH)
            make.bottom.equalTo(bottomLogoImageView.snp.top).offset(-75.adjustedH)
        }
        
        bottomLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.greaterThanOrEqualTo(100)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30.adjustedH)
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
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.retrieveAlpha()
        })
    }
    
    private func updateLogoY() {
        logoImageView.transform = CGAffineTransform(translationX: 0, y: -Metric.logoMutableY)
    }
    
    private func retrieveAlpha() {
        [signInButton, notMemberButton, bottomLogoImageView].forEach {
            $0.alpha = 1
        }
    }
}

// MARK: - Methods

extension SignInVC {
    
    private func bindViews() {
        signInButton.publisher(for: .touchUpInside)
            .withUnretained(self)
            .sink { owner, _ in
                owner.openPlaygroundURL()
            }.store(in: self.cancelBag)
        
        notMemberButton.publisher(for: .touchUpInside)
            .withUnretained(self)
            .sink { owner, _ in
                owner.setRootViewToMain()
            }.store(in: self.cancelBag)
    }
    
    private func bindViewModels() {
        let signInFinished = Driver.just(accessCode)
            .drop { [weak self] code in
                return code == nil
                || self?.requestState != UserDefaultKeyList.Auth.requestState
            }
            .replaceNil(with: "")
            .eraseToAnyPublisher()
            .asDriver()
        
        let input = SignInViewModel.Input(
            playgroundSignInFinished: signInFinished
        )
        let output = self.viewModel.transform(from: input, cancelBag: cancelBag)
        
        output.isSignInSuccess
            .removeDuplicates()
            .sink { [weak self] type in
                guard let self = self else { return }
                
                switch type {
                case .loginSuccess:
                    self.setRootViewToMain()
                case .unregistedProfile:
                    self.setRootViewToMain(isInActiveUser: true)
                case .loginFailure: break
                }
            }.store(in: self.cancelBag)
    }
    
    private func setRootViewToMain(isInActiveUser: Bool = false) {
        let userType = isInActiveUser ? .unregisteredInactive : UserDefaultKeyList.Auth.getUserType()
        let navigation = UINavigationController(rootViewController: factory.makeMainVC(userType: userType).viewController)
        ViewControllerUtils.setRootViewController(window: self.view.window!, viewController: navigation, withAnimation: true)
    }
    
    private func openPlaygroundURL() {
        let state = UUID().uuidString
        UserDefaultKeyList.Auth.requestState = state
        guard let url = URL(string: ExternalURL.Playground.login(state: state)) else {
            SentrySDK.capture(message: "Invalid URL string: \(ExternalURL.Playground.login(state: state))")
            makeAlert(title: "URL 에러", message: "잘못된 URL이 생성되었습니다. 개발자에게 문의주시면 감사하겠습니다.")
            return
        }
        let safari = SFSafariViewController(url: url)
        safari.modalPresentationStyle = .fullScreen
        safari.playgroundStyle()
        self.present(safari, animated: true)
    }
}
