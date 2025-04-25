//
//  FABMenuHeaderView.swift
//  TabBarFeature
//
//  Created by 강윤서 on 4/13/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit

final class FABMenuHeaderView: UICollectionReusableView {
      
    // MARK: - UI Components
    
    private let sectionTitle = UILabel().then{
        $0.font = DSKitFontFamily.Suit.medium.font(size: 12)
        $0.textColor = DSKitAsset.Colors.gray950.color
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

extension FABMenuHeaderView {
    private func setLayout() {
        addSubviews(sectionTitle)
        
        sectionTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension FABMenuHeaderView {
    public func configureCell(title: String) {
        sectionTitle.text = title
    }
}
