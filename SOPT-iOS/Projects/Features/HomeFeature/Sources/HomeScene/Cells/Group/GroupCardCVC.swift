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

final class GroupCardCVC: UICollectionViewCell {
    
    // MARK: - Properties

    private var tagTextList: [String] = []
    private var isSizeCalculated: Bool = false
    
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
        $0.textColor = DSKitAsset.Colors.white.color
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
    }
    
    private lazy var joinableConditionTagCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.createColletionViewLayout()
    ).then {
        $0.isScrollEnabled = false
        $0.showsHorizontalScrollIndicator = false
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.tagTextList.removeAll()
        needToCalculateContentHeight()
    }
    
    /// 셀의 높이를 동적으로 계산합니다.
    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        self.layoutIfNeeded()
        let updatedAttributes = calculateContentHeight(layoutAttributes)
        return updatedAttributes
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
            joinableConditionTagCollectionView
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
        
        joinableConditionTagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    /// joinableConditionTagCollectionView: 높이 업데이트
    private func updateJoinableConditionTagCollectionViewConstraints() {
        let collectionViewHeight = self.joinableConditionTagCollectionView.collectionViewLayout.collectionViewContentSize.height
        self.joinableConditionTagCollectionView.snp.updateConstraints { make in
            make.height.equalTo(collectionViewHeight)
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
        reloadJoinableConditionTagCollectionView(model)
        makeTitleAttributedString(category: model.category, title: model.title)
    }
    
    /// 자격 요건 태그 콜렉션뷰: 데이터 append 이후 reload
    private func reloadJoinableConditionTagCollectionView(_ model: GroupInfo) {
        self.tagTextList.removeAll()
        self.tagTextList.append(model.canJoinAllParts ? I18N.Home.Group.entireGeneration : I18N.Home.Group.activityGeneration)
        self.tagTextList += model.joinableParts
        
        self.joinableConditionTagCollectionView.reloadData()
        self.joinableConditionTagCollectionView.layoutIfNeeded()
        
        updateJoinableConditionTagCollectionViewConstraints()
    }

    /// contentHeight를 다시 계산하도록 하는 플래그
    private func needToCalculateContentHeight() {
        self.isSizeCalculated = false
    }
    
    /// 카테고리 + 모임글 타이틀
    private func makeTitleAttributedString(category: GroupCategoryTagType, title: String) {
        let attributedText = "\(category.text) \(title)"
        self.titleLabel.text = attributedText
        self.titleLabel.partColorChange(targetString: category.text, textColor: category.textColor)
    }
    
    /// coverImageView (정적) + titleLabel (동적) + joinableConditionTagCollectionView (동적) 높이 계산
    private func calculateContentHeight(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        /// isSizeCalculated: 이미 계산되었을 경우 early return
        if self.isSizeCalculated { return layoutAttributes }
        
        /// coverImageView: 높이
        let coverImageViewHeight = coverImageView.frame.height
        
        /// titleLabel: 높이
        let titleHeight = titleLabel.frame.height
        
        /// joinableConditionTagCollectionView: 내부 content 높이 계산
        let collectionViewHeight = joinableConditionTagCollectionView.collectionViewLayout.collectionViewContentSize.height

        /// 전체 셀 크기 계산
        let itemSpacing = 21.0
        let totalHeight = coverImageViewHeight + titleHeight + collectionViewHeight + itemSpacing
        
        var frame = layoutAttributes.frame
        frame.size.height = totalHeight
        layoutAttributes.frame = frame
        
        self.isSizeCalculated = true
        
        return layoutAttributes
    }
}

// MARK: - CollectionView Methods

extension GroupCardCVC {
    private func setDelegate() {
        self.joinableConditionTagCollectionView.delegate = self
        self.joinableConditionTagCollectionView.dataSource = self
    }
    
    private func registerCells() {
        self.joinableConditionTagCollectionView.register(GroupRoundTagCVC.self,
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
        cell.configureCell(text: tagTextList[indexPath.item])
        return cell
    }
}
