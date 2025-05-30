//
//  CustomButton.swift
//  DSKit
//
//  Created by sejin on 2022/11/23.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core

public final class AppCustomButton: UIButton {
    
    // MARK: - Properties
    
    private var config = UIButton.Configuration.plain()
    private var title: AttributedString
    
    // MARK: - Initialize
    
    public init(title: String = "") {
        self.title = AttributedString(title)
        super.init(frame: .zero)
        
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension AppCustomButton {
    /// 버튼의 enable 여부 설정
    @discardableResult
    public func setEnabled(_ isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }
    
    /// 버튼의 text 설정
    @discardableResult
    public func setTitle(_ title: String) -> Self {
        self.title = AttributedString(title)
        return self
    }
    
    /// content의 edge 변경
    @discardableResult
    public func changeInset(inset: NSDirectionalEdgeInsets) -> Self {
        config.contentInsets = inset
        self.configuration = config
        
        return self
    }
    
    /// 버튼의 cornerRadius 변경
    @discardableResult
    public func changeCornerRadius(radius: Double) -> Self {
        config.background.cornerRadius = radius
        self.configuration = config
        
        return self
    }
    
    /// 버튼의 enable, disable에 따른 상태 변경
    @discardableResult
    public func setConfigForState(
        bgColor: UIColor = DSKitAsset.Colors.white.color,
        disabledColor: UIColor = DSKitAsset.Colors.gray600.color,
        disabledTextColor: UIColor = DSKitAsset.Colors.gray60.color,
        disabledFont: UIFont = DSKitFontFamily.Suit.bold.font(size: 18),
        enabledTextColor: UIColor = DSKitAsset.Colors.black100.color,
        enabledFont: UIFont = DSKitFontFamily.Suit.bold.font(size: 18)
    ) -> Self {
        
        self.configurationUpdateHandler = { button in
            var updatedConfig = button.configuration ?? .plain()
            switch button.state {
            case .disabled:
                updatedConfig.background.backgroundColor = disabledColor
                self.title.foregroundColor = disabledTextColor
                self.title.font = disabledFont
            default:
                updatedConfig.background.backgroundColor = bgColor
                self.title.foregroundColor = enabledTextColor
                self.title.font = enabledFont
            }
            updatedConfig.attributedTitle = self.title
            button.configuration = updatedConfig
        }
                
        return self
    }
}

// MARK: - UI & Layout

extension AppCustomButton {
    private func setUI() {
        
        /// 초기 상태
        self.title.font = DSKitFontFamily.Suit.bold.font(size: 18)
        config.attributedTitle = self.title
        config.background.cornerRadius = 10
        self.configuration = config
        
        self.configurationUpdateHandler = { button in
            var updatedConfig = button.configuration ?? .plain()
            switch button.state {
            case .disabled:
                updatedConfig.background.backgroundColor = DSKitAsset.Colors.gray600.color
                self.title.foregroundColor = DSKitAsset.Colors.gray60.color
            default:
                updatedConfig.background.backgroundColor = DSKitAsset.Colors.white.color
                self.title.foregroundColor = DSKitAsset.Colors.black100.color
            }
            updatedConfig.attributedTitle = self.title
            button.configuration = updatedConfig
        }
    }
}
