//
//  SoptletterPostItCollectionViewCell.swift
//  SoptletterFeature
//
//  Created by dev on 6/29/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//


import UIKit

import Core
import DSKit
import MDS

import SnapKit

final class SoptletterPostItCell: UICollectionViewCell, UICollectionViewRegisterable {

    // MARK: - Properties

    static var isFromNib: Bool = false

    private let maxNumberOfLines = 5

    private let backgroundImageView = UIImageView().then {
        $0.clipsToBounds = false
        $0.contentMode = .scaleAspectFit
    }

    private let contentLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 5
        $0.lineBreakMode = .byTruncatingTail
    }

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func prepareForReuse() {
        super.prepareForReuse()

        backgroundImageView.image = nil
        contentLabel.text = nil
        contentLabel.transform = .identity
    }
}

extension SoptletterPostItCell {
    private func setUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    private func setLayout() {
        contentView.addSubviews(backgroundImageView, contentLabel)

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.directionalHorizontalEdges.equalToSuperview().inset(BaseSpacing.Base.s24)
        }
    }
}

extension SoptletterPostItCell {
    @discardableResult
    func configure(
        text: String,
        textColor: UIColor,
        backgroundImage: UIImage?,
        labelRotationAngle: CGFloat = 0,
        backgroundColorHex: String,
        shapeType: String
    ) -> Self {
            contentLabel.text = text
            contentLabel.setTypography(Typography.body2, textColor: textColor)

            let rotation = CGAffineTransform(rotationAngle: labelRotationAngle * .pi / 180)
            contentLabel.transform = rotation
            backgroundImageView.transform = rotation

            let shape = SoptletterShapeMapping(rawValue: shapeType.uppercased()) ?? .point
            let shapeImage: UIImage?

            switch shape {
            case .sharp:
                shapeImage = DSKitAsset.Assets.icnPointBlueCenter.image
            case .cloud:
                shapeImage = DSKitAsset.Assets.icnCloudRedCenter.image
            case .smooth:
                shapeImage = DSKitAsset.Assets.icnSmoothRedCenter.image
            case .point:
                shapeImage = DSKitAsset.Assets.icnSquareSky.image
            }

            backgroundImageView.image = shapeImage?.withRenderingMode(.alwaysTemplate)
            backgroundImageView.tintColor = UIColor(hex: backgroundColorHex)
        return self
    }
}

enum SoptletterShapeMapping: String {
    case sharp = "SHARP"
    case cloud = "CLOUD"
    case smooth = "SMOOTH"
    case point = "POINT"

    init(shapeStyle: String) {
        self = SoptletterShapeMapping(rawValue: shapeStyle.uppercased()) ?? .point
    }
}
