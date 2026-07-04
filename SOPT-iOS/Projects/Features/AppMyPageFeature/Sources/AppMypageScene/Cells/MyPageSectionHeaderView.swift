//
//  MyPageSectionHeaderView.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit

final class MyPageSectionHeaderView: UICollectionReusableView {
      
    // MARK: - UI Components
    
    private let sectionTitle = UILabel().then{
        $0.font = DSKitFontFamily.Suit.medium.font(size: 12)
        $0.textColor = DSKitAsset.Colors.gray80.color
    }
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension MyPageSectionHeaderView {
    private func setLayout() {
        addSubviews(sectionTitle)
        
        sectionTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.lessThanOrEqualToSuperview().inset(8)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension MyPageSectionHeaderView {
    public func configureCell(title: String) {
        sectionTitle.text = title
    }
}

