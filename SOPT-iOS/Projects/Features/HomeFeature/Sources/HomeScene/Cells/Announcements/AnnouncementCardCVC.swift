//
//  AnnouncementCardCVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/28/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class AnnouncementCardCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let categoryTagView = HomeCategoryTagView()
    
    private let dividerImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icVerticalDivider.image
        $0.contentMode = .scaleAspectFit
    }
    
    private let categoryDetailLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.white.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 12)
    }
    
    private let categoryStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = 10
    }
    
    private let writerProfileImageView = CustomProfileImageView()
    
    private let writerNameLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.white.color
        $0.font = DSKitFontFamily.Suit.regular.font(size: 13)
    }
    
    private let writerInfoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.white.color
        $0.font = DSKitFontFamily.Suit.bold.font(size: 16)
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let contentLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray300.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 14)
        $0.lineBreakMode = .byTruncatingTail
        $0.textAlignment = .left
    }
    
    private let coverImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 12
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStackView()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension AnnouncementCardCVC {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.gray900.color
        self.layer.cornerRadius = 12
    }
    
    private func setLayout() {
        self.addSubviews(contentStackView)
        
        writerProfileImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        
        coverImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(160)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(14)
        }
    }
    
    private func setStackView() {
        categoryStackView.addArrangedSubviews(
            categoryTagView,
            dividerImageView,
            categoryDetailLabel
        )
        
        writerInfoStackView.addArrangedSubviews(
            writerProfileImageView,
            writerNameLabel
        )
        
        contentStackView.addArrangedSubviews(
            categoryStackView,
            writerInfoStackView,
            titleLabel,
            contentLabel,
            coverImageView
        )
    }
}

// MARK: - Methods

extension AnnouncementCardCVC {
    func configureCell(model: AnnouncementInfo) {
        self.categoryTagView.setData(with: model.categoryName, isHotTag: false)
        self.categoryDetailLabel.text = model.categoryDetailName
        self.writerProfileImageView.setImage(with: model.profileImage)
        self.writerNameLabel.text = model.name
        self.titleLabel.text = model.title
        self.contentLabel.text = model.content
        
        let hasCoverImage = (model.images != nil)
        updateContentLayout(hasCoverImage: hasCoverImage)
        if hasCoverImage, let cover = model.images {
            self.coverImageView.setImage(with: cover)
        } else {
            updateContentLabelAttributes()
        }
    }
    
    /// 사진이 있을 경우: content 한 줄 제한, 없을 경우: 이미지뷰 없이 제한 없는 content
    private func updateContentLayout(hasCoverImage: Bool) {
        if hasCoverImage {
            self.coverImageView.isHidden = false
            self.contentLabel.numberOfLines = 1
        } else {
            self.coverImageView.isHidden = true
            self.contentLabel.numberOfLines = 0
        }
    }
    
    /// contentLabel이 여러 줄일 경우
    private func updateContentLabelAttributes() {
        self.contentLabel.setLineSpacing(lineSpacing: 4)
        self.contentLabel.lineBreakStrategy = .hangulWordPriority
        self.contentLabel.numberOfLines = 9
        self.contentLabel.lineBreakMode = .byTruncatingTail
    }
}
