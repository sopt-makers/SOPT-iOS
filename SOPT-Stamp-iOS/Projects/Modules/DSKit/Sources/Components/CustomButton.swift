//
//  CustomButton.swift
//  DSKit
//
//  Created by sejin on 2022/11/23.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core

public class CustomButton: UIButton {
    
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

extension CustomButton {
    /// 버튼의 enable 여부 설정
    @discardableResult
    public func setEnabled(_ isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }
    
    /// 버튼의 Title 변경
    @discardableResult
    public func changeTitle(attributedString: String) -> Self {
        let string = NSAttributedString(string: attributedString, attributes: [.font: UIFont.h2, .foregroundColor: self.titleLabel?.textColor ?? .white])
        self.setAttributedTitle(string, for: .normal)
        return self
    }
    
    /// 버튼의 backgroundColor, textColor 변경
    @discardableResult
    public func setColor(bgColor: UIColor, disableColor: UIColor, _ textColor: UIColor = .white) -> Self {
        self.setBackgroundColor(bgColor, for: .normal)
        self.setBackgroundColor(disableColor, for: .disabled)
        self.setAttributedTitle(
            NSAttributedString(
                string: self.titleLabel?.text ?? "",
                attributes: [.font: UIFont.h2, .foregroundColor: textColor]),
            for: .normal)
        
        return self
    }
}

// MARK: - UI & Layout

extension CustomButton {
    private func setUI(_ title: String) {
        self.layer.cornerRadius = 9
        
        self.setBackgroundColor(DSKitAsset.Colors.purple300.color, for: .normal)
        self.setBackgroundColor(DSKitAsset.Colors.purple200.color, for: .disabled)
        self.setAttributedTitle(
            NSAttributedString(
                string: title,
                attributes: [.font: UIFont.h2, .foregroundColor: UIColor.white]
            ),
            for: .normal
        )
    }
}
