//
//  InsightCardCVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class InsightCardCVC: UICollectionViewCell {
    
    // MARK: - Properties

    private let categoryTagView = HomeCategoryTagView()
    
    private let verticalDividerView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icVerticalDivider.image
        $0.contentMode = .scaleAspectFit
    }
    
    private let profileImageView = CustomProfileImageView().hideBorder()
    
    private let userNameLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray100.color
        $0.font = DSKitFontFamily.Suit.regular.font(size: 13)
    }
    
    private let categoryStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    private let postTitleLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.white100.color
        $0.font = DSKitFontFamily.Suit.bold.font(size: 16)
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 6
    }

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setStackView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension InsightCardCVC {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.gray800.color
        self.layer.cornerRadius = 12
    }

    private func setLayout() {
        self.addSubview(contentStackView)
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        
        categoryStackView.setCustomSpacing(10, after: categoryTagView)
        categoryStackView.setCustomSpacing(10, after: verticalDividerView)
        categoryStackView.setCustomSpacing(4, after: profileImageView)
        
        contentStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(14)
        }
    }
    
    private func setStackView() {
        categoryStackView.addArrangedSubviews(
            categoryTagView,
            verticalDividerView,
            profileImageView,
            userNameLabel
        )
        
        contentStackView.addArrangedSubviews(
            categoryStackView,
            postTitleLabel
        )
    }
}

// MARK: - Methods

extension InsightCardCVC {
    func configureCell(model: InsightInfo) {
        self.categoryTagView.setData(with: model.category, isHotTag: model.isHotTag)
        self.profileImageView.setImage(with: model.profileImageURL)
        self.userNameLabel.text = model.userName
        self.postTitleLabel.text = model.postTitle
    }
}
