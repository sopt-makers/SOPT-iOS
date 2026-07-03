//
//  MyPageSoptlogStatCVC.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 2026/06/29.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit

import SnapKit
import Then

import Core
import DSKit

final class MyPageSoptlogStatCVC: UICollectionViewCell {

    // MARK: - Metric

    private enum Metric {
        static let iconBackgroundSize: CGFloat = 39
    }

    // MARK: - UI Components

    private let iconBackgroundView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray700.color
        $0.layer.cornerRadius = Metric.iconBackgroundSize / 2
    }

    private let iconView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = DSKitAsset.Colors.white.color
    }

    private let titleLabel = UILabel()

    private let countLabel = UILabel()

    // MARK: - Init

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

extension MyPageSoptlogStatCVC {
    private func setUI() {
        backgroundColor = .clear
    }

    private func setLayout() {
        iconBackgroundView.addSubview(iconView)
        contentView.addSubviews(iconBackgroundView, titleLabel, countLabel)

        iconBackgroundView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(23)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(Metric.iconBackgroundSize)
        }

        iconView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(22)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconBackgroundView.snp.trailing).offset(14)
            $0.centerY.equalTo(iconBackgroundView)
        }

        countLabel.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(33)
            $0.centerY.equalTo(iconBackgroundView)
        }
    }
}

// MARK: - Methods

extension MyPageSoptlogStatCVC {
    func configure(icon: UIImage?, title: String, count: Int) {
        iconView.image = icon
        titleLabel.attributedText = title.applyMDSFont(mdsFont: .body3, color: DSKitAsset.Colors.gray200.color)
        countLabel.attributedText = "\(count)회".applyMDSFont(mdsFont: .heading7, color: DSKitAsset.Colors.white.color)
    }
}
