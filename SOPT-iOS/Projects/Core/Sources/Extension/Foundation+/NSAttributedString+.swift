//
//  NSAttributedString+.swift
//  Core
//
//  Created by Jae Hyun Lee on 5/17/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

public extension NSAttributedString {
    
    /// string 값에서 html 태그를 적용해주는 함수
    /// - defaultFont, defaultColor에는 기본 폰트와 컬러를 넣어주세요
    static func fromHTML(
        _ html: String,
        defaultFont: UIFont,
        boldFont: UIFont? = nil,
        defaultColor: UIColor
    ) -> NSAttributedString {
        guard let data = html.data(using: .utf8) else {
            return NSAttributedString(string: html, attributes: [
                .font: defaultFont,
                .foregroundColor: defaultColor
            ])
        }
        do {
            let attributed = try NSMutableAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            let range = NSRange(location: 0, length: attributed.length)
            attributed.enumerateAttribute(.font, in: range, options: []) { value, range, _ in
                let currentFont = value as? UIFont
                let isBold = currentFont?.fontName.lowercased().contains("bold") == true
                attributed.addAttribute(
                    .font,
                    value: isBold ? (boldFont ?? defaultFont) : defaultFont,
                    range: range
                )
            }
            attributed.addAttribute(.foregroundColor, value: defaultColor, range: range)
            return attributed
        } catch {
            return NSAttributedString(string: html, attributes: [
                .font: defaultFont,
                .foregroundColor: defaultColor
            ])
        }
    }
}
