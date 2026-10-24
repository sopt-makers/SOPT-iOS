//
//  UITextView+.swift
//
//  Created by Junho Lee on 2022/09/24.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import MDS

public extension UITextView {

    /// 입력된 글자 중 `font`가 렌더링하지 못하는 글자(일부 이모지·특수문자 등)에만 `fallbackFont`를 적용합니다.
    /// 텍스트뷰의 현재 `text`로 `attributedText`를 다시 만들기 때문에, 글자가 바뀐 뒤(`textViewDidChange` 등)에 호출합니다.
    /// - Parameters:
    ///   - font: 기본으로 사용할 폰트입니다.
    ///   - fallbackFont: `font`가 지원하지 않는 글자에 쓸 폰트입니다. nil이면 `font`와 같은 크기의 시스템 폰트를 사용합니다.
    ///   - color: 글자색입니다. 
    func applyFontFallback(
        font: UIFont,
        fallbackFont: UIFont? = nil,
        color: UIColor
    ) {
        /// 입력된 글자를 전부 받아옵니다.
        let fullText = text ?? ""
        let fallbackFont = fallbackFont ?? UIFont.systemFont(ofSize: font.pointSize)

        /// 현재 attributedText를 복사해서 시작합니다. 줄 간격(paragraphStyle), 자간(kern) 같은 기존 속성은 유지하고 폰트와 색만 바꿉니다.
        let attributedString = NSMutableAttributedString(
            attributedString: attributedText ?? NSAttributedString(string: fullText)
        )

        /// 전체 글자를 돌면서 폰트 지원이 안되면 fallback으로 설정합니다.
        /// 조합 문자(이모지 등)는 UTF-16 코드유닛 길이가 1을 초과할 수 있으므로 오프셋을 직접 누적합니다.
        var utf16Offset = 0
        for character in fullText {
            let characterString = String(character)
            let length = characterString.utf16.count
            let range = NSRange(location: utf16Offset, length: length)
            /// 공백·줄바꿈은 윤곽선이 없어 `canBeRendered`가 false를 반환하므로, 폴백 대상에서 제외합니다. 
            let hasNoOutline = character.isWhitespace || character.isNewline
            let fontToUse = hasNoOutline || characterString.canBeRendered(by: font) ? font : fallbackFont
            attributedString.addAttribute(.font, value: fontToUse, range: range)
            attributedString.addAttribute(.foregroundColor, value: color, range: range)
            utf16Offset += length
        }

        /// attributedText를 할당하면 커서가 끝으로 이동하므로, 기존 선택 범위를 복원합니다.
        let selection = selectedRange
        attributedText = attributedString
        selectedRange = selection
    }

    /// MDS 타이포를 텍스트뷰에 적용하되, 줄 높이를 `minimumLineHeight`/`maximumLineHeight`가 아니라 `lineSpacing`으로 맞춥니다.
    /// UITextView에서 `setTypography`가 UILabel과 줄 간격이 다르게 그려질 때 사용합니다.
    /// 현재 `text`로 `attributedText`를 다시 만들고, 이후 입력되는 글자도 같은 스타일이 되도록 `typingAttributes`를 설정합니다.
    /// - Parameters:
    ///   - style: 적용할 MDS 타이포입니다. 줄 높이는 `style.lineHeight`가 됩니다.
    ///   - textColor: 글자색입니다.
    func setTypographyUsingLineSpacing(_ style: MDSFont, textColor: UIColor) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = style.lineHeight - style.font.lineHeight

        let attributes: [NSAttributedString.Key: Any] = [
            .font: style.font,
            .kern: style.letterSpacing,
            .foregroundColor: textColor,
            .paragraphStyle: paragraph
        ]

        let selection = selectedRange
        attributedText = NSAttributedString(string: text ?? "", attributes: attributes)
        typingAttributes = attributes
        selectedRange = selection
    }

    /// 자간 설정 메서드
    func setCharacterSpacing(_ spacing: CGFloat) {
        let attributedStr = NSMutableAttributedString(string: self.text ?? "")
        attributedStr.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, attributedStr.length))
        self.attributedText = attributedStr
    }
    
    /// 세로 중앙정렬 메서드
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
    /// line 수 카운트 메서드
    func numberOfLines() -> Int {
        let layoutManager = layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange: NSRange = NSMakeRange(0, 1)
        var index = 0
        var numberOfLines = 0

        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
    
    /// 행간 조정 메서드
    func setLineSpacing(lineSpacing: CGFloat) {
        if let text = self.text {
            let color = self.textColor
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
        
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: color ?? .white,
                .paragraphStyle: style
            ]

            let attrText = NSMutableAttributedString(string: text)
            attrText.addAttributes(attributes, range: NSRange(location: 0, length: text.count))
            
            self.attributedText = attrText
        }
    }
}
