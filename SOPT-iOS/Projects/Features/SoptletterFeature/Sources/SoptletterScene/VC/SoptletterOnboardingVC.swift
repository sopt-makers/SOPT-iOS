//
//  SoptletterOnboardingVC.swift
//  SoptletterFeature
//
//  Created by 최주리 on 5/25/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit

import Then

import Core
import DSKit
import SoptletterFeatureInterface

public final class SoptletterOnboardingVC: UIViewController, SoptletterOnboardingViewControllable {
    public var onNaviBackTap: (() -> Void)?
    public var onStartButtonTap: (() -> Void)?
    
    private let imageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.imgLetterOnboarding.image
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .bottom
    }
    
    private let titleImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.soptletterTitleKr.image
        $0.contentMode = .scaleAspectFit
    }
    
    private let secondTitleImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.soptletterTitleEn.image
        $0.contentMode = .scaleAspectFit
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = I18N.Soptletter.Onboarding.descriptionText
        $0.font = DSKitFontFamily.Suit.medium.font(size: 16)
        $0.textColor = DSKitAsset.Colors.gray200.color
        $0.numberOfLines = 3
        $0.textAlignment = .center
    }
    
    private lazy var startButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = DSKitAsset.Colors.white.color
        config.background.cornerRadius = 12
        
        var attributeContainer = AttributeContainer()
        attributeContainer.font = DSKitFontFamily.Suit.semiBold.font(size: 18)
        attributeContainer.foregroundColor = DSKitAsset.Colors.black.color
        
        config.attributedTitle = AttributedString(I18N.Soptletter.Onboarding.startButtonTitle, attributes: attributeContainer)
        $0.configuration = config
        $0.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    private lazy var backButton = UIButton().then {
        $0.setImage(DSKitAsset.Assets.xMark.image.withTintColor(DSKitAsset.Colors.gray10.color), for: .normal)
        $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
    }
}

extension SoptletterOnboardingVC {
    private func setUI() {
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
    }
    
    private func setLayout() {
        view.addSubviews(imageView, titleStackView, descriptionLabel, startButton, backButton)
        titleStackView.addArrangedSubviews(titleImageView, secondTitleImageView)
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(32)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(158)
            $0.centerX.equalToSuperview()
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).offset(-83)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
    }
}

extension SoptletterOnboardingVC {
    @objc
    private func startButtonTapped() {
        onStartButtonTap?()
    }
    
    @objc
    private func backButtonTapped() {
        onNaviBackTap?()
    }
}
