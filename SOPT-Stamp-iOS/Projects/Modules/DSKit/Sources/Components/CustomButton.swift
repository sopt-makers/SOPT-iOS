//
//  CustomButton.swift
//  DSKit
//
//  Created by sejin on 2022/11/23.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core

final class CustomButton: UIButton {
    
    // MARK: - Initialize

    init(title: String) {
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
    func setEnabled(_ isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }
    
    /// 버튼의 Title 변경
    @discardableResult
    func changeTitle(attributedString: NSAttributedString) -> Self {
        self.setAttributedTitle(attributedString, for: .normal)
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
