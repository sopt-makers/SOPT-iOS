//
//  AppOutlinedButton.swift
//  DSKit
//
//  Created by 강윤서 on 9/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

public final class AppOutlinedButton: UIButton {
    
    // MARK: - Properties
    private var config = UIButton.Configuration.plain()
	
	// MARK: - Initialize
	
	public init(title: String) {
		super.init(frame: .zero)
		self.setUI(title)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Methods

extension AppOutlinedButton {
    /// 버튼의 backgroundColor, textColor 변경
    @discardableResult
    public func setColor(
        outlinedColor: UIColor = DSKitAsset.Colors.gray100.color,
        textColor: UIColor = DSKitAsset.Colors.gray100.color
    ) -> Self {
        
        self.setAttributedTitle(
            NSAttributedString(
                string: self.titleLabel?.text ?? "",
                attributes: [.font: DSKitFontFamily.Suit.semiBold.font(size: 14),
                    .foregroundColor: textColor]),
            for: .normal
        )
        
        config.background.strokeColor = outlinedColor
        
        return self
    }
}

// MARK: - UI & Layout

extension AppOutlinedButton {
	private func setUI(_ title: String) {
		
		config.baseBackgroundColor = .clear
		config.background.strokeColor = DSKitAsset.Colors.white100.color
		config.background.strokeWidth = 1.0
		config.cornerStyle = .capsule
		
		var attributedTitle = AttributedString(title)
		attributedTitle.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
		attributedTitle.foregroundColor = DSKitAsset.Colors.white100.color
		config.attributedTitle = attributedTitle
		
		self.configuration = config
	}
}
