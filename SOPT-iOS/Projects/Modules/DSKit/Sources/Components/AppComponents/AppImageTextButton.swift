//
//  AppImageTextButton.swift
//  DSKit
//
//  Created by 장석우 on 10/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

public final class AppImageTextButton: UIButton {
    
    private let font: UIFont?
    
    public override var isEnabled: Bool {
        didSet { updateUI() }
    }
    
    public override var isHighlighted: Bool {
        didSet { updateUI() }
    }
    
    // MARK: - Initialize
    
    public init(
        title: String,
        image: UIImage? = nil,
        font: UIFont? = DSKitFontFamily.Suit.semiBold.font(size: 16)
    ) {
        self.font = font
        
        super.init(frame: .zero)
        self.setUI(title, image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension AppImageTextButton {
    
    public func updateTitle(_ title: String) {
        var attributedTitle = AttributedString(title)
        attributedTitle.font = font
        self.configuration?.attributedTitle = attributedTitle
    }
    
    private func setUI(_ title: String, _ image: UIImage?) {
        
        var config = UIButton.Configuration.filled()
        var attributedTitle = AttributedString(title)
        attributedTitle.font = font
        config.attributedTitle = attributedTitle
        
        if let image = image {
            config.image = image
            config.imagePadding = 3
            config.imagePlacement = .leading
        }
        
        self.configuration = config
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        updateUI()
    }
    
    private func updateUI() {
        let bg = isEnabled ? isHighlighted ?
        DSKitAsset.Colors.gray100 : DSKitAsset.Colors.white : DSKitAsset.Colors.gray800
        let fg = isEnabled ?
        DSKitAsset.Colors.black : DSKitAsset.Colors.gray500
        
        configuration?.baseBackgroundColor = bg.color
        configuration?.baseForegroundColor = fg.color
    }
}


