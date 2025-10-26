//
//  ClapButton.swift
//  StampFeature
//
//  Created by 최주리 on 10/19/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class ClapButton: UIButton {
    init() {
        super.init(frame: .zero)
        
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ClapButton {
    func setCount(_ count: Int) {
        let attributedString = NSAttributedString(
            string: String(count),
            attributes: [
                .font: DSKitFontFamily.Suit.bold.font(size: 20),
                .foregroundColor: UIColor.white
            ]
        )
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

// MARK: - UI & Layout

extension ClapButton {
    private func setUI() {
        let attributedString = NSAttributedString(
            string: "0",
            attributes: [.font: DSKitFontFamily.Suit.bold.font(size: 20), .foregroundColor: UIColor.white]
        )
        self.setAttributedTitle(attributedString, for: .normal)

        self.configuration = UIButton.Configuration.bordered()
        self.configurationUpdateHandler = { button in
            guard var configuration = button.configuration else { return }
            
            configuration.image = DSKitAsset.Assets.icClap.image.withRenderingMode(.alwaysTemplate)
            configuration.imageColorTransformer = UIConfigurationColorTransformer { _ in
                if button.isEnabled {
                    DSKitAsset.Colors.white.color
                } else {
                    DSKitAsset.Colors.gray400.color
                }
            }
            configuration.imagePadding = 8
            configuration.cornerStyle = .capsule
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 18, bottom: 12, trailing: 18)
            
            configuration.background.cornerRadius = 20
            configuration.background.strokeWidth = 1
            configuration.background.strokeColor = DSKitAsset.Colors.gray700.color
            if button.isHighlighted {
                configuration.baseBackgroundColor = DSKitAsset.Colors.gray800.color
            } else {
                configuration.baseBackgroundColor = DSKitAsset.Colors.gray900.color
            }

            button.configuration = configuration
        }
    }
}
