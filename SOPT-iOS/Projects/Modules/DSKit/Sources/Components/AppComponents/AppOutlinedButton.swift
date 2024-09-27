//
//  AppOutlinedButton.swift
//  DSKit
//
//  Created by 강윤서 on 9/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

public final class AppOutlinedButton: UIButton {
	
	// MARK: - Initialize
	
	public init(title: String) {
		super.init(frame: .zero)
		self.setUI(title)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - UI & Layout

extension AppOutlinedButton {
	private func setUI(_ title: String) {
		
		var config = UIButton.Configuration.plain()
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
