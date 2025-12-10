//
//  SoptlogEmptyCVC.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 1/21/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit
import SnapKit

final class SoptlogEmptyCVC: UICollectionViewCell {

    // MARK: - UI Components

    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DSKitAsset.Assets.icEyes.image
        imageView.tintColor = DSKitAsset.Colors.gray700.color
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = DSKitFontFamily.Suit.medium.font(size: 14)
        label.textColor = DSKitAsset.Colors.gray500.color
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension SoptlogEmptyCVC {
    private func setUI() {
        contentView.backgroundColor = .clear
    }

    private func setLayout() {
        contentView.addSubviews(emptyImageView, emptyLabel)

        emptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(48)
            make.size.equalTo(43)
        }

        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyImageView.snp.bottom).offset(10)
        }
    }
}

// MARK: - Configuration

extension SoptlogEmptyCVC {
    func configure(text: String) {
        emptyLabel.text = text
    }
}
