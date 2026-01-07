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

import SnapKit

final class AppJamRankingHeaderView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = DSKitFontFamily.Suit.bold.font(size: 20)
        label.textColor = DSKitAsset.Colors.white.color
        return label
    }()
    
    private let titleImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = DSKitFontFamily.Suit.medium.font(size: 14)
        label.textColor = DSKitAsset.Colors.gray300.color
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

extension AppJamRankingHeaderView {
    private func setUI() {
        backgroundColor = .clear
    }
    
    private func setLayout() {
        addSubviews(titleLabel, subtitleLabel, titleImage)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview()
        }
        
        titleImage.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(1)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Configuration

extension AppJamRankingHeaderView {
    func configure(title: String, subtitle: String, image: UIImage) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        titleImage.image = image
    }
}

