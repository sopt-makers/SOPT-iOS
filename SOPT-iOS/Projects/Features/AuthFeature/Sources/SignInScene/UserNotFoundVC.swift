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
import MDS

public final class UserNotFoundVC: UIViewController, UserNotFoundRoutingTrigger {

    // MARK: - Properties
    
    public var onLoginHelpButtonTapped: (() -> Void)?
    public var onLoginRetryButtonTapped: (() -> Void)?
    private var cancelBag = CancelBag()
    private static let i18n = I18N.SignIn.Refactor.self
    
    // MARK: - UI Components
    
    private let imageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.imgLogoBig.image
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        let fullText = i18n.userNotFound
        let attributedString = NSMutableAttributedString(
            string: fullText,
            attributes: Typography.title2.attributedStringAttributes(foregroundColor: SemanticColor.Fg.Neutral.bold)
        )
        let range = (fullText as NSString).range(of: I18N.SignIn.Refactor.userInfo)
        attributedString.addAttribute(.foregroundColor, value: SemanticColor.Fg.Brand.default, range: range)
        $0.attributedText = attributedString
    }

    private let descriptionLabel = UILabel().then {
        $0.text = i18n.signUpFirst
        $0.setTypography(Typography.label2, textColor: SemanticColor.Fg.Neutral.subtle)
    }

    private let loginRetryButton = MDSActionButton(variant: .primary, size: .large, title: i18n.retryLogin)

    private let loginHelpButton = MDSTextButton(variant: .emphasis, size: .medium, title: i18n.helpLogin)

    
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
        self.view.backgroundColor = SemanticColor.Bg.Layer.basement
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
            $0.bottom.equalTo(titleLabel.snp.top).offset(-BaseSpacing.Base.s8)
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(12)
        }

        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(BaseSpacing.Base.s8)
        }
        
        loginRetryButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(loginHelpButton.snp.top).offset(-BaseSpacing.Base.s24)
        }
        
        loginHelpButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24.adjustedH)
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
