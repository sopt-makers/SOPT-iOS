//
//  HomeCustomTextWithArrowButton.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class HomeCustomTextWithArrowButton: UIButton {

    // MARK: - Initialization

    init(title: String) {
        super.init(frame: .zero)
        setUI(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension HomeCustomTextWithArrowButton {
    private func setUI(_ title: String) {
        self.setBackgroundColor(.clear, for: .normal)
        
        self.configuration = UIButton.Configuration.plain()

        self.configurationUpdateHandler = { button in
            guard var configuration = button.configuration else { return }
            configuration.contentInsets = .zero

            /// 타이틀 설정
            var attributedTitle = AttributedString(title)
            var attributes = AttributeContainer()
            attributes.font = DSKitFontFamily.Suit.semiBold.font(size: 12)
            attributes.foregroundColor = DSKitAsset.Colors.gray300.color
            attributedTitle.setAttributes(attributes)
            configuration.attributedTitle = attributedTitle
            
            /// 이미지 설정
            configuration.image = DSKitAsset.Assets.chevronRight.image.withTintColor(DSKitAsset.Colors.gray300.color)
            configuration.imagePlacement = .trailing
            
            button.configuration = configuration
        }
    }
}
