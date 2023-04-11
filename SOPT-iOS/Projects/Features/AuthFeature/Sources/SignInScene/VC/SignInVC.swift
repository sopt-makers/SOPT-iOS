//
//  SignInVC.swift
//  Presentation
//
//  Created by devxsby on 2022/12/01.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import DSKit

import Core

import Domain

import Combine
import SnapKit
import Then

import AuthFeatureInterface
import MainFeatureInterface

public class SignInVC: UIViewController, SignInViewControllable {
    
    // MARK: - Properties
    
    public var factory: (AuthFeatureViewBuildable & MainFeatureViewBuildable)!
    public var viewModel: SignInViewModel!
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
        self.setUI()
        self.setLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showAnimation()
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
    
    private func showAnimation() {
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
            self.logoImageView.transform = CGAffineTransform(translationX: 0, y: -Metric.logoMutableY)
        })
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            [self.signInButton, self.notMemberButton, self.bottomLogoImageView].forEach {
                $0.alpha = 1
            }
        })
    }
}

// MARK: - Methods

extension SignInVC {
    
    private func bindViewModels() {
        
        let input = SignInViewModel.Input(playgroundSignInFinished: Driver.just(""))
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.isSignInSuccess.sink { [weak self] isSignInSuccess in
            guard let self = self else { return }
            self.stopLoading()
            if isSignInSuccess {
                self.setRootViewToMain()
            }
        }.store(in: self.cancelBag)
    }
    
    private func setRootViewToMain() {
        let userType = UserDefaultKeyList.Auth.getUserType()
        let navigation = UINavigationController(rootViewController: factory.makeMainVC(userType: userType).viewController)
        ViewControllerUtils.setRootViewController(window: self.view.window!, viewController: navigation, withAnimation: true)
    }
}
