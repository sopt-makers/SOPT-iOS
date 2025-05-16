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
    private var title: AttributedString
	
	// MARK: - Initialize
	
	public init(title: String) {
        self.title = AttributedString(title)
        super.init(frame: .zero)
        
        self.setUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Methods

extension AppOutlinedButton {
    /// 버튼의 outlinedColor변경
    @discardableResult
    public func chageOutlinedColor(outlinedColor: UIColor) -> Self {
        config.background.strokeColor = outlinedColor
        self.configuration = config
        
        return self
    }
    
    /// 버튼의 textColor변경
    @discardableResult
    public func chageTextColor(textColor: UIColor) -> Self {
        self.title.foregroundColor = textColor
        config.attributedTitle = self.title
        self.configuration = config
        
        return self
    }
}

// MARK: - UI & Layout

extension AppOutlinedButton {
	private func setUI() {
		
		config.baseBackgroundColor = .clear
		config.background.strokeColor = DSKitAsset.Colors.white.color
		config.background.strokeWidth = 1.0
		config.cornerStyle = .capsule
		
        self.title.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
        self.title.foregroundColor = DSKitAsset.Colors.white.color
        config.attributedTitle = self.title
		
		self.configuration = config
	}
}
