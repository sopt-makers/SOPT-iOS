//
//  LoginHelpBottomSheetVC.swift
//  AuthFeature
//
//  Created by 장석우 on 10/23/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import BaseFeatureDependency
import Core
import Domain
import MDS

public final class LoginHelpBottomSheetVC: UIViewController, LoginHelpBottomSheetRoutingTrigger {
    
    private static let i18n = I18N.SignIn.Refactor.self
    public var onWantToKnowLoginAccountButtonDidTap: (() -> Void)?
    public var onResetSocialAccountButtonDidTap: (() -> Void)?
    public var onInquireToKakaoTalkButtonDidTap: (() -> Void)?
    private let cancelBag = CancelBag()
    
    public var minimumContentHeight: CGFloat {
        return 206.adjusted
    }
    
    // MARK: - Views
    
    private let warnImageView = UIImageView().then {
        $0.image = MDSIcon.alertCircleOutlined.image.withRenderingMode(.alwaysTemplate)
        $0.tintColor = SemanticColor.Fg.Neutral.bold
    }

    private let titleLabel = UILabel().then {
        $0.text = i18n.helpLogin
        $0.setTypography(Typography.title3, textColor: SemanticColor.Fg.Neutral.bold)
    }

    private let wantToKnowAccountButton = LoginHelpOptionButton(title: i18n.wantToKnowAccount)
    private let resetSocialAccountButton = LoginHelpOptionButton(title: i18n.resetSocialAccount)
    private let inquireToKakaoTalkButton = LoginHelpOptionButton(title: i18n.inquireToKakaoTalk)

    private lazy var optionButtonStackView = UIStackView(
        arrangedSubviews: [wantToKnowAccountButton, resetSocialAccountButton, inquireToKakaoTalkButton]
    ).then {
        $0.axis = .vertical
        $0.spacing = BaseSpacing.Base.s4
    }

    public init() {
        super.init(nibName: nil, bundle: nil)

        self.view.backgroundColor = SemanticColor.Bg.Neutral.ghost

        self.setLayout()
        self.bindAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginHelpBottomSheetVC {
    
    private func setLayout() {
        
        self.view.addSubviews(
            warnImageView,
            titleLabel,
            optionButtonStackView
        )

        self.warnImageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(19)
            $0.leading.equalToSuperview().inset(12)
        }

        self.titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(warnImageView)
            $0.leading.equalTo(warnImageView.snp.trailing).offset(BaseSpacing.Base.s4)
        }

        [wantToKnowAccountButton, resetSocialAccountButton, inquireToKakaoTalkButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(44)
            }
        }

        self.optionButtonStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(BaseSpacing.Base.s12)
            $0.horizontalEdges.equalToSuperview().inset(BaseSpacing.Base.s8)
            $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(8)
        }
    }
    
    
    private func bindAction() {
        wantToKnowAccountButton
            .publisher(for: .touchUpInside)
            .asDriver()
            .withUnretained(self)
            .sink { owner, _ in
                owner.onWantToKnowLoginAccountButtonDidTap?()
            }
            .store(in: cancelBag)
        
        resetSocialAccountButton
            .publisher(for: .touchUpInside)
            .asDriver()
            .withUnretained(self)
            .sink { owner, _ in
                owner.onResetSocialAccountButtonDidTap?()
            }
            .store(in: cancelBag)
        
        inquireToKakaoTalkButton
            .publisher(for: .touchUpInside)
            .asDriver()
            .withUnretained(self)
            .sink { owner, _ in
                owner.onInquireToKakaoTalkButtonDidTap?()
            }
            .store(in: cancelBag)
    }
}

private final class LoginHelpOptionButton: UIButton {

    init(title: String) {
        super.init(frame: .zero)

        self.configureUI(title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI(title: String) {
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString(
            NSAttributedString(string: title,
                               attributes: Typography.body2.attributedStringAttributes(foregroundColor: SemanticColor.Fg.Neutral.bold))
        )
        configuration.contentInsets = .init(top: BaseSpacing.Base.s10,
                                            leading: BaseSpacing.Base.s10,
                                            bottom: BaseSpacing.Base.s10,
                                            trailing: 0)
        configuration.background.cornerRadius = BaseRadius.Base.r8
        self.configuration = configuration

        self.contentHorizontalAlignment = .leading
        self.configurationUpdateHandler = { button in
            button.configuration?.background.backgroundColor = button.isHighlighted
            ? SemanticColor.Bg.Neutral.Ghost.hover
            : .clear
        }
    }
}
