//
//  InsightCardCVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Domain
import Core
import DSKit

final class InsightCardCVC: UICollectionViewCell {
    
    // MARK: - Properties

    private let categorySubPhraseView = HomeCategoryTagView()

    private let verticalDividerView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icVerticalDivider.image
        $0.contentMode = .scaleAspectFit
    }
    
    private let categoryTagView = HomeCategoryTagView()
    
    private let profileImageView = CustomProfileImageView().hideBorder()
    
    private let userNameLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray30.color
        $0.font = DSKitFontFamily.Suit.regular.font(size: 10)
    }
    
    private let userPartLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray400.color
        $0.font = DSKitFontFamily.Suit.regular.font(size: 10)
    }
    
    private let categoryStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
    }
    
    private let userStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }
    
    private let postTitleLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.white100.color
        $0.font = DSKitFontFamily.Suit.bold.font(size: 16)
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let postContentLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray500.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 12)
        $0.numberOfLines = 2
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
        self.addSubviews(userStackView, contentStackView)
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(50)
        }
        
        userStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.centerY.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.leading.equalTo(userStackView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(22)
            make.top.equalToSuperview().inset(21)
        }
    }
    
    private func setStackView() {
        categoryStackView.addArrangedSubviews(
            categorySubPhraseView,
            verticalDividerView,
            categoryTagView
        )
        
        userStackView.addArrangedSubviews(
            profileImageView,
            userNameLabel,
            userPartLabel
        )
        
        userStackView.setCustomSpacing(5, after: profileImageView)
        userStackView.setCustomSpacing(1, after: userNameLabel)
        
        contentStackView.addArrangedSubviews(
            categoryStackView,
            postTitleLabel,
            postContentLabel
        )
    }
}

// MARK: - Methods

extension InsightCardCVC {
    func configureCell(model: HomePresentationModel.InsightPost) {
        self.categorySubPhraseView.setData(with: "활동기수의 따끈한 새소식")
        self.categoryTagView.setData(with: model.category)
        self.userNameLabel.text = "김차돌"
        self.userPartLabel.text = "32기 기획"
        if let profileImage = model.profileImage {
            self.profileImageView.setImage(with: profileImage)
        }
        self.postTitleLabel.text = "나 메이커스팀인데 메팀 좋다"
        self.postContentLabel.text = "본문 내용은 두줄로 보여줍니다. 본문 내용은 두줄로 보여줍니다.본문 내용은 두줄로 보여줍니다."
        self.postContentLabel.setLineSpacing(lineSpacing: 1)
    }
}
