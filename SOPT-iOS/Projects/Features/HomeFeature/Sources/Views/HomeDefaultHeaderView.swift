//
//  HomeDefaultHeaderView.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class HomeDefaultHeaderView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.bold.font(size: 20)
        $0.textColor = DSKitAsset.Colors.white100.color
    }
    
    private let viewAllButton = HomeCustomTextWithArrowButton(title: "전체보기")
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension HomeDefaultHeaderView {
    private func setLayout() {
        self.addSubviews(
            titleLabel,
            viewAllButton
        )
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
        }
        
        viewAllButton.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension HomeDefaultHeaderView {
    func setData(sectionKind: HomeForMemberSectionLayoutKind) {
        self.titleLabel.text = sectionKind.title
        if sectionKind == .appService { self.viewAllButton.isHidden = true }
    }
}



