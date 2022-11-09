//
//  setTypoStyle.swift
//  DSKit
//
//  Created by 양수빈 on 2022/10/13.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//
import UIKit

import Core

public extension UILabel {
    @discardableResult
    func setTypoStyle(_ typo: UIFont, _ spacing: CGFloat = -1) -> Self {
        self.font = typo
        self.setCharacterSpacing(spacing)
        return self
    }
}

public extension UITextView {
    @discardableResult
    func setTypoStyle(_ typo: UIFont, _ spacing: CGFloat = -1) -> Self {
        self.font = typo
        self.setCharacterSpacing(spacing)
        return self
    }
}
