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

public final class OAuthView: UIView {
    
    private static let i18n = I18N.Auth.OAuth.self
    
    //MARK: - Properties
    
    let googleLoginButton = AppImageTextButton(
        title: i18n.googleLogin,
        image: DSKitAsset.Assets.logoGoogle.image
    )
    
    let appleLoginButton = AppImageTextButton(
        title: i18n.appleLogin,
        image: DSKitAsset.Assets.logoApple.image
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
        self.backgroundColor = DSKitAsset.Colors.black100.color
    }
    
    private func setLayout() {
        self.addSubviews(
            googleLoginButton,
            appleLoginButton
        )

        
        googleLoginButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
            
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(googleLoginButton.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview()
        }
       
    }
}
