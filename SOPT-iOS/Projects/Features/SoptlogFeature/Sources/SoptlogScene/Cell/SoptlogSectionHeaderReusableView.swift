//
//  SoptlogSectionHeaderReusableView.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import MDS

final class SoptlogSectionHeaderReusableView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setTypography(Typography.title4, textColor: SemanticColor.Fg.Neutral.bold)
        label.numberOfLines = 1
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

extension SoptlogSectionHeaderReusableView {
    private func setUI() {
        backgroundColor = .clear
    }
    
    private func setLayout() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(12)
        }
    }
}

// MARK: - Configuration

extension SoptlogSectionHeaderReusableView {
    func configure(title: String) {
        titleLabel.text = title
        titleLabel.setTypography(Typography.title4, textColor: SemanticColor.Fg.Neutral.bold)
    }
}
