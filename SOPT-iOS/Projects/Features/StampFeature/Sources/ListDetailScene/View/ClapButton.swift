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

public final class ClapButton: UIButton {
    public init() {
        super.init(frame: .zero)
        
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ClapButton {
    public func setEnabled(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
    
    public func setCount(_ count: Int) {
        self.setAttributedTitle(
            NSAttributedString(
                string: String(count),
                attributes: [.font: DSKitFontFamily.Suit.bold.font(size: 20), .foregroundColor: UIColor.white]
            ),
            for: .normal
        )
    }
}

// MARK: - UI & Layout

extension ClapButton {
    private func setUI() {
        let attributedString = NSAttributedString(
            string: "999",
            attributes: [.font: DSKitFontFamily.Suit.bold.font(size: 20), .foregroundColor: UIColor.white]
        )
        
        var config = UIButton.Configuration.bordered()
        config.image = DSKitAsset.Assets.icClap.image.withRenderingMode(.alwaysTemplate)
        config.imageColorTransformer = UIConfigurationColorTransformer { _ in
            if self.isEnabled {
                DSKitAsset.Colors.white.color
            } else {
                DSKitAsset.Colors.gray400.color
            }
        }
        config.imagePadding = 8
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 18, bottom: 12, trailing: 18)
        config.background.cornerRadius = 20
        config.background.strokeWidth = 1
        config.background.strokeColor = DSKitAsset.Colors.gray700.color
        config.background.backgroundColor = DSKitAsset.Colors.gray900.color
        config.attributedTitle = AttributedString(attributedString)
        config.cornerStyle = .capsule
        
        self.configuration = config
        self.configurationUpdateHandler = { button in
            self.updateConfig()
        }
    }
    
    private func updateConfig() {
        guard var config = self.configuration else { return }
        
        if self.isSelected {
            config.background.backgroundColor = DSKitAsset.Colors.gray800.color
        } else {
            config.background.backgroundColor = DSKitAsset.Colors.gray900.color
        }
        
        self.configuration = config
    }
}
