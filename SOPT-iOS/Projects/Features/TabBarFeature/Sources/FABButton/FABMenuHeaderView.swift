//
//  FABMenuHeaderView.swift
//  HomeFeature
//
//  Created by 성현주 on 11/30/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//


import UIKit

import MDS

final class FABMenuHeaderView: UICollectionReusableView {
      
    // MARK: - UI Components
    
    private let sectionTitle = UILabel()
    
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
    func configureCell(title: String) {
        sectionTitle.text = title
        sectionTitle.setTypography(Typography.label4, textColor: SemanticColor.Fg.Neutral.ghost)
    }
}
