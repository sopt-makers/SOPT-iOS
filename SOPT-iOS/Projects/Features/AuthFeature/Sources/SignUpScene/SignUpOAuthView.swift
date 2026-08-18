//
//  SignUpOAuthView.swift
//  AuthFeature
//
//  Created by 장석우 on 1/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import MDS

final class SignUpOAuthView: UIView {
    
    private static let i18n = I18N.Auth.SocialLink.self

    public var viewModelInput: SignUpViewModel.Input.OAuth {
        .init(
            googleLoginTapped: oAuthView.googleLoginButton.publisher(for: .touchUpInside).mapVoid().asDriver(),
            appleLoginTapped: oAuthView.appleLoginButton.publisher(for: .touchUpInside).mapVoid().asDriver()
        )
    }

    //MARK: - Properties

    private let titleLabel = UILabel().then {
        $0.text = i18n.title
        $0.setTypography(Typography.heading2, textColor: SemanticColor.Fg.Neutral.bold)
        $0.textAlignment = .center
    }

    private let descriptionLabel = UILabel().then {
        $0.text = i18n.description
        $0.setTypography(Typography.body3, textColor: SemanticColor.Fg.Neutral.subtle)
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    private let oAuthView = OAuthView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUI() {
        self.backgroundColor = SemanticColor.Bg.Layer.basement
    }

    private func setLayout() {
        self.addSubviews(
            titleLabel,
            descriptionLabel,
            oAuthView
        )

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(BaseSpacing.Base.s8)
            $0.centerX.equalToSuperview()
        }

        oAuthView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(BaseSpacing.Base.s64)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
}
