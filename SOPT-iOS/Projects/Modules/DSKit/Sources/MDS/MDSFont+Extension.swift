//
//  MDSFont+Extension.swift
//  DSKit
//
//  Created by Ian on 6/2/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

// NOTE(@승호): MDSFont Utils.
// https://www.figma.com/design/ZuAGH1zZDxduHsjCZm8kfH/makers-design-system?node-id=1108-449&t=MModRhfeVMnp4tml-4
extension String {
  public func applyMDSFont(
    mdsFont: UIFont.MDS,
    color: UIColor,
    alignment: NSTextAlignment = .left,
    lineBreakMode: NSLineBreakMode = .byTruncatingTail
  ) -> NSMutableAttributedString {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineBreakMode = lineBreakMode
    paragraphStyle.minimumLineHeight = mdsFont.lineHeight
    paragraphStyle.alignment = alignment
    
    if lineBreakMode == .byWordWrapping {
      paragraphStyle.lineBreakStrategy = .hangulWordPriority
    }
    
    let attributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: color,
      .font: mdsFont.font,
      .kern: mdsFont.letterSpacing,
      .paragraphStyle: paragraphStyle,
      .baselineOffset: (paragraphStyle.minimumLineHeight - mdsFont.font.lineHeight) / 4
    ]
    
    let attrText = NSMutableAttributedString(string: self)
    attrText.addAttributes(attributes, range: NSRange(location: 0, length: self.utf16.count))
    return attrText
  }
}
