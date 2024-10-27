//
//  UserNotFoundVC.swift
//  AuthFeature
//
//  Created by 장석우 on 10/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core
import DSKit



public final class UserNotFoundVC: UIViewController, UserNotFoundViewControllable {

    // MARK: - Properties
    
    public var onLoginHelpButtonTapped: (() -> Void)?
    public var onLoginRetryButtonTapped: (() -> Void)?
    private var cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    private let imageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.imgLogoBig.image
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.text = I18N.SignIn.userNotFound
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 24)
        $0.textColor = .white
        $0.partColorChange(targetString: I18N.SignIn.userInfo, textColor: DSKitAsset.Colors.secondary.color)
    }

    
    private let descriptionLabel = UILabel().then {
        $0.text = I18N.SignIn.signUpFirst
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 18)
        $0.textColor = .white
    }

    
    private let loginRetryButton = AppCustomButton(title: I18N.SignIn.retryLogin)
        .setFontColor(customFont: DSKitFontFamily.Suit.semiBold.font(size: 18))
    
    private let loginHelpButton = UIButton(type: .system).then {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = DSKitAsset.Colors.gray30.color
        config.baseBackgroundColor = .clear
        
        var attributedTitle = AttributedString(I18N.SignIn.helpLogin)
        attributedTitle.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
        config.attributedTitle = attributedTitle
        
        config.image = DSKitAsset.Assets.chevronRight.image.withTintColor(DSKitAsset.Colors.gray30.color).withRenderingMode(.alwaysTemplate)
        config.imagePadding = 0
        config.imagePlacement = .trailing
        
        $0.configuration = config
    }

    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindActions()
        self.setUI()
        self.setLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

// MARK: - UI & Layout

extension UserNotFoundVC {
    
    private func setUI() {
        self.view.backgroundColor = DSKitAsset.Colors.soptampBlack.color
    }
    
    private func setLayout() {
        self.view.addSubviews(
            imageView,
            titleLabel,
            descriptionLabel,
            loginRetryButton,
            loginHelpButton
        )
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(194.adjusted)
            $0.bottom.equalTo(titleLabel.snp.top).offset(-8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(12)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
        }
        
        loginRetryButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
            $0.bottom.equalTo(loginHelpButton.snp.top).offset(-16)
        }
        
        loginHelpButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(28.adjustedH)
        }
        

    }

}

// MARK: - Methods

extension UserNotFoundVC {
    func bindActions() {
        loginRetryButton
            .publisher(for: .touchUpInside)
            .asDriver()
            .withUnretained(self)
            .sink { owner, _ in
                owner.onLoginRetryButtonTapped?()
            }
            .store(in: cancelBag)
        
        loginHelpButton
            .publisher(for: .touchUpInside)
            .asDriver()
            .withUnretained(self)
            .sink { owner, _ in
                owner.onLoginHelpButtonTapped?()
            }
            .store(in: cancelBag)
    }
}
