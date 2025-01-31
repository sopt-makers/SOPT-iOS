//
//  CoffeeChatCardCVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/28/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Domain
import Core
import DSKit

struct GenerationTagInfo {
    let title: String
    let isActive: Bool
}

final class CoffeeChatCardCVC: UICollectionViewCell {
    
    // MARK: - Properties

    private var generationTagTextList: [GenerationTagInfo] = []
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.white.color
        $0.font = DSKitFontFamily.Suit.bold.font(size: 16)
        $0.numberOfLines = 0
        $0.lineBreakStrategy = .hangulWordPriority
    }
    
    private let categoryTagStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = 4
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray600.color
    }
    
    private let hostProfileImageView = CustomProfileImageView().hideBorder()
    
    private let hostNameLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray100.color
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
    }
    
    private let hostJobLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray400.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 13)
    }
    
    private lazy var hostGenerationHistoryCollecitonView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.createColletionViewLayout()
    ).then {
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
    }
    
    private let hostInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 8
    }
    
    private let hostProfileStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = 16
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 16
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStackView()
        setUI()
        setLayout()
        setDelegate()
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.categoryTagStackView.removeAllSubViews()
    }
}

// MARK: - UI & Layout

extension CoffeeChatCardCVC {
    private func createColletionViewLayout() -> UICollectionViewFlowLayout {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }
    
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.gray900.color
        self.layer.cornerRadius = 20
    }
    
    private func setLayout() {
        self.addSubviews(contentStackView)
        
        dividerView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
        
        hostProfileImageView.snp.makeConstraints { make in
            make.size.equalTo(70)
        }
        
        hostGenerationHistoryCollecitonView.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.width.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(24)
        }
    }
    
    private func setStackView() {
        hostInfoStackView.addArrangedSubviews(
            hostNameLabel,
            hostJobLabel,
            hostGenerationHistoryCollecitonView
        )
        
        hostProfileStackView.addArrangedSubviews(
            hostProfileImageView,
            hostInfoStackView
        )
        
        contentStackView.addArrangedSubviews(
            titleLabel,
            categoryTagStackView,
            dividerView,
            hostProfileStackView
        )
    }
}

// MARK: - Methods

extension CoffeeChatCardCVC {
    func configureCell(model: HomeCoffeeChatPostModel?) {
        guard let model else { return }

        self.titleLabel.text = model.bio
        makeCategoryTagView(categories: model.topicTypeList)
        
        if let profileImage = model.profileImage {
            self.hostProfileImageView.setImage(with: profileImage)
        }
        
        if let career = model.career {
            self.hostNameLabel.text = "\(model.name) | \(career)"
        } else {
            self.hostNameLabel.text = model.name
        }
        
        self.hostJobLabel.text = [model.organization, model.companyJob]
            .compactMap { $0 }
            .joined(separator: " | ")
        
        self.generationTagTextList = []
        
        /// 현재 활동 중인 기수 정보가 있을 때
        if let currentSoptActivity = model.currentSoptActivity {
            self.generationTagTextList.append(GenerationTagInfo(title: currentSoptActivity, isActive: true))
        }
        
        /// 과거 활동했던 기수 정보들 추가
        self.generationTagTextList += model.soptActivities.map {
            GenerationTagInfo(title: $0, isActive: false)
        }
    }
    
    private func makeCategoryTagView(categories: [String]) {
        for category in categories {
            let categoryTag = HomeSquareTagView()
            categoryTag.setData(title: category,
                                titleColor: DSKitAsset.Colors.success.color,
                                backgroundColor: DSKitAsset.Colors.success.color.withAlphaComponent(0.2))
            self.categoryTagStackView.addArrangedSubviews(categoryTag)
        }
    }
}

// MARK: - CollectionView Methods

extension CoffeeChatCardCVC {
    private func setDelegate() {
        self.hostGenerationHistoryCollecitonView.delegate = self
        self.hostGenerationHistoryCollecitonView.dataSource = self
    }
    
    private func registerCells() {
        self.hostGenerationHistoryCollecitonView.register(CoffeeChatRoundTagCVC.self,
                                                          forCellWithReuseIdentifier: CoffeeChatRoundTagCVC.className)
    }
}

// MARK: - UICollectionViewDelegate

extension CoffeeChatCardCVC: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension CoffeeChatCardCVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.generationTagTextList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: CoffeeChatRoundTagCVC.className,
                                 for: indexPath) as? CoffeeChatRoundTagCVC else { return UICollectionViewCell() }
        cell.setData(info: generationTagTextList[safe: indexPath.item])
        return cell
    }
}
