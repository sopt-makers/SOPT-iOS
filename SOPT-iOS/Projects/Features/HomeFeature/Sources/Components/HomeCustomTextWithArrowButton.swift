//
//  HomeCustomTextWithArrowButton.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class HomeCustomTextWithArrowButton: UIButton {

    // MARK: - Initialization

    init(title: String) {
        super.init(frame: .zero)
        setUI(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension HomeCustomTextWithArrowButton {
    private func setUI(_ title: String) {
        self.setBackgroundColor(.clear, for: .normal)
        
        /// 텍스트 지정
        let font = DSKitFontFamily.Suit.semiBold.font(size: 12)
        let foregroundColor = DSKitAsset.Colors.gray300.color

        let attributedText = NSAttributedString(
            string: title,
            attributes: [
                .font: font,
                .foregroundColor: foregroundColor
            ]
        )
        
        /// 이미지 지정
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = DSKitAsset.Assets.chevronRight.image.withTintColor(DSKitAsset.Colors.gray300.color)

        let imageSize = CGSize(width: 16, height: 16)
        imageAttachment.bounds = CGRect(x: 0,
                                        y: (font.lineHeight - imageSize.height) / 2 + font.descender,
                                        width: imageSize.width,
                                        height: imageSize.height)
        
        let attributedImage = NSAttributedString(attachment: imageAttachment)
        
        /// 텍스트 + 이미지 결합
        let combinedAttributedString = NSMutableAttributedString()
        combinedAttributedString.append(attributedText)
        combinedAttributedString.append(attributedImage)
        
        /// 타이틀 지정
        self.setAttributedTitle(
            combinedAttributedString,
            for: .normal
        )
    }
}
