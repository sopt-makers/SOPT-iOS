//
//  GroupCardCVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

@frozen
enum RecruitmentStatusType: String {
    case beforeStart = "BEFORE_START"
    case applyAble = "APPLY_ABLE"
    case recruitmentComplete = "RECRUITMENT_COMPLETE"
    
    var text: String {
        switch self {
        case .beforeStart:
            return I18N.Home.Group.beforeStart
        case .applyAble:
            return I18N.Home.Group.applyAble
        case .recruitmentComplete:
            return I18N.Home.Group.recruitmentComplete
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .beforeStart:
            return DSKitAsset.Colors.gray800.color
        case .applyAble:
            return DSKitAsset.Colors.gray800.color
        case .recruitmentComplete:
            return DSKitAsset.Colors.gray800.color
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .beforeStart:
            return DSKitAsset.Colors.attention.color
        case .applyAble:
            return DSKitAsset.Colors.secondary.color
        case .recruitmentComplete:
            return DSKitAsset.Colors.gray100.color
        }
    }
}

final class GroupCardCVC: UICollectionViewCell {
    
    // MARK: - Properties

    private var tagTextList: [String] = []
    
    // MARK: - UI Components
    
    private let coverImageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.contentMode = .scaleToFill
    }
    
    private var recruitmentStatusTagView = HomeSquareTagView()
    
    private let titleLabel = UILabel().then {
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 2
    }
    
    private let eligibilityTagContentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
    }
    
    private lazy var eligibilityTagCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.createColletionViewLayout()
    ).then {
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setDelegate()
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension GroupCardCVC {
    private func createColletionViewLayout() -> UICollectionViewFlowLayout {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }

    private func setLayout() {
        self.addSubviews(
            coverImageView,
            recruitmentStatusTagView,
            titleLabel,
            eligibilityTagCollectionView
        )
        
        coverImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(coverImageView.snp.width).multipliedBy(0.68)
        }
        
        recruitmentStatusTagView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
        }
        
        eligibilityTagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension GroupCardCVC {
    func configureCell(model: GroupInfo) {
        self.coverImageView.setImage(with: model.imageURL)
        self.titleLabel.text = model.title
        self.recruitmentStatusTagView.setData(title: model.status.text,
                                              titleColor: model.status.textColor,
                                              backgroundColor: model.status.backgroundColor)
        
        self.tagTextList.append(model.canJoinAllParts ? I18N.Home.Group.entireGeneration : I18N.Home.Group.activityGeneration)
        self.tagTextList += model.joinableParts
        
        switch model.category {
        case .event:
            return makeTitleAttributedString(category: .event, title: model.title)
        case .study:
            return makeTitleAttributedString(category: .study, title: model.title)
        }
    }
     
    /// 카테고리 + 모임글 타이틀
    private func makeTitleAttributedString(category: GroupCategoryType, title: String) {
        let categoryString = NSAttributedString(string: category.text,
                                                attributes: [
                                                    .foregroundColor: category.textColor,
                                                    .font: DSKitFontFamily.Suit.semiBold.font(size: 14)
                                                ])
        let titleString = NSAttributedString(string: " " + title,
                                             attributes: [
                                                .foregroundColor: DSKitAsset.Colors.gray10.color,
                                                .font: DSKitFontFamily.Suit.semiBold.font(size: 14)
                                             ])
        let attrString = NSMutableAttributedString()
        attrString.append(categoryString)
        attrString.append(titleString)
        titleLabel.attributedText = attrString
    }
}

// MARK: - CollectionView Methods

extension GroupCardCVC {
    private func setDelegate() {
        self.eligibilityTagCollectionView.delegate = self
        self.eligibilityTagCollectionView.dataSource = self
    }
    
    private func registerCells() {
        self.eligibilityTagCollectionView.register(GroupRoundTagCVC.self,
                                                   forCellWithReuseIdentifier: GroupRoundTagCVC.className)
    }
}
        
// MARK: - UICollectionViewDelegate
        
extension GroupCardCVC: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
        
extension GroupCardCVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tagTextList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: GroupRoundTagCVC.className,
                                 for: indexPath) as? GroupRoundTagCVC else { return UICollectionViewCell() }
        cell.setData(with: tagTextList[indexPath.item])
        return cell
    }
}
