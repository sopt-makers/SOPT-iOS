//
//  AppJamRankingHeaderView.swift
//  StampFeature
//
//  Created by 강윤서 on 12/16/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit
import MDS

import SnapKit

final class AppJamRankingHeaderView: UICollectionReusableView {

    // MARK: - UI Components

    private let titleLabel = UILabel()

    private let titleImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let subtitleLabel = UILabel()
    
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

extension AppJamRankingHeaderView {
    private func setUI() {
        backgroundColor = .clear
    }
    
    private func setLayout() {
        addSubviews(titleLabel, subtitleLabel, titleImage)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(BaseSpacing.Base.s16)
            make.leading.equalToSuperview()
        }

        titleImage.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(1)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(BaseSpacing.Base.s6)
            make.bottom.equalToSuperview().inset(BaseSpacing.Base.s20)
        }
    }
}

// MARK: - Configuration

extension AppJamRankingHeaderView {
    func configure(title: String, subtitle: String, image: UIImage) {
        titleLabel.text = title
        titleLabel.setTypography(Typography.heading3, textColor: SemanticColor.Fg.Neutral.bold)

        subtitleLabel.text = subtitle
        subtitleLabel.setTypography(Typography.body2, textColor: SemanticColor.Fg.Neutral.subtle)

        titleImage.image = image
    }
}

