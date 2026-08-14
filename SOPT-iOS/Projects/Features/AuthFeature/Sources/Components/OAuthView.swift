//
//  OAuthView.swift
//  AuthFeature
//
//  Created by 장석우 on 6/6/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Combine
import DSKit
import MDS

public final class OAuthView: UIView {

    private static let i18n = I18N.Auth.OAuth.self

    //MARK: - Properties

    let googleLoginButton = MDSActionButton(
        variant: .primary,
        size: .medium,
        title: i18n.googleLogin,
        prefixIcon: .googleColorFilled
    )

    let appleLoginButton = MDSActionButton(
        variant: .primary,
        size: .medium,
        title: i18n.appleLogin,
        prefixIcon: .appleFilled
    )

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
            googleLoginButton,
            appleLoginButton
        )

        googleLoginButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }

        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(googleLoginButton.snp.bottom).offset(BaseSpacing.Base.s10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
