//
//  SoptletterCheckNicknameVC.swift
//  SoptletterFeature
//
//  Created by 최주리 on 6/21/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit
import Core
import SoptletterFeatureInterface

public final class SoptletterCheckNicknameVC: UIViewController, SoptletterNicknameCheckViewControllable {
    public var onNaviBackTap: (() -> Void)?
    public var onGoButtonTap: (() -> Void)?
    
    // TODO: - 추후 기수 연결
    private let number: Int = 12
    
    private let cardView: NicknameCheckCardView = {
        let view = NicknameCheckCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var button = UIButton().then {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = DSKitAsset.Colors.white.color
        config.background.cornerRadius = 12
        
        var attributeContainer = AttributeContainer()
        attributeContainer.font = DSKitFontFamily.Suit.semiBold.font(size: 18)
        attributeContainer.foregroundColor = DSKitAsset.Colors.black.color
        
        config.attributedTitle = AttributedString("\(number)" + I18N.Soptletter.Onboarding.goButtonTitle, attributes: attributeContainer)
        $0.configuration = config
        $0.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
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

extension SoptletterCheckNicknameVC {
    private func setUI() {
        view.backgroundColor = DSKitAsset.Colors.semanticBackground.color
    }
    
    private func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubviews(backButton, cardView, button)
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top).offset(12)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(32)
        }
        cardView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        button.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).offset(-83)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
    }
}

extension SoptletterCheckNicknameVC {
    @objc
    private func goButtonTapped() {
        onGoButtonTap?()
    }
    
    @objc
    private func backButtonTapped() {
        onNaviBackTap?()
    }
}
