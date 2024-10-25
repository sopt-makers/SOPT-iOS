//
//  AppImageTextButton.swift
//  DSKit
//
//  Created by 장석우 on 10/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

public final class AppImageTextButton: UIButton {
    
    
    //TODO: disabled 상태일 때 config background 설정 기능 필요
    
    public override var isHighlighted: Bool {
        didSet {
            self.configuration?.baseBackgroundColor = isHighlighted ? DSKitAsset.Colors.gray100.color : DSKitAsset.Colors.white.color
        }
    }
    
    // MARK: - Initialize
    
    public init(title: String, image: UIImage? = nil) {
        super.init(frame: .zero)
        self.setUI(title, image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension AppImageTextButton {
    private func setUI(_ title: String, _ image: UIImage?) {
        
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = DSKitAsset.Colors.black.color
        config.baseBackgroundColor = DSKitAsset.Colors.white.color
        
        
        var attributedTitle = AttributedString(title)
        attributedTitle.font = DSKitFontFamily.Suit.semiBold.font(size: 16)
        attributedTitle.foregroundColor = DSKitAsset.Colors.black.color
        config.attributedTitle = attributedTitle
        
        if let image = image {
            config.image = image
            config.imagePadding = 3
            config.imagePlacement = .leading
        }
        
        self.configuration = config
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
}
