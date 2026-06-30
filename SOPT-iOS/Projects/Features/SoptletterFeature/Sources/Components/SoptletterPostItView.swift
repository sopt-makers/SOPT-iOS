//
//  SoptletterPostItView.swift
//  SoptletterFeature
//
//  Created by dev on 6/29/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//


import UIKit

import Core
import DSKit

import SnapKit

final class SoptletterPostItView: UIView {

    // MARK: - Properties
    
    private let maxNumberOfLines = 5

    private let backgroundImageView = UIImageView().then {
        $0.clipsToBounds = false
        $0.contentMode = .scaleAspectFit
    }

    private let contentLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.medium.font(size: 14)
        $0.textColor = DSKitAsset.Colors.gray800.color
        $0.textAlignment = .center
        $0.numberOfLines = 5
        $0.lineBreakMode = .byTruncatingTail
    }

    public init() {
        super.init(frame: .zero)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SoptletterPostItView {
    private func setUI() {
        backgroundColor = .clear
    }

    private func setLayout() {
        addSubviews(backgroundImageView, contentLabel)

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
    }
}

extension SoptletterPostItView {
    @discardableResult
    func configure(
        text: String,
        textColor: UIColor,
        backgroundImage: UIImage?,
        labelRotationAngle: CGFloat = 0
    ) -> Self {
        contentLabel.text = text
        contentLabel.textColor = textColor
        backgroundImageView.image = backgroundImage
        contentLabel.transform = CGAffineTransform(rotationAngle: CGFloat(labelRotationAngle) * .pi / 180)
        return self
    }
}
