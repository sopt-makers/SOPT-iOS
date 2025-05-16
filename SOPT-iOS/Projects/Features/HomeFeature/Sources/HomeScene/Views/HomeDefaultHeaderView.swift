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

    private let titleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = 8
    }
    
    private let viewAllButton = HomeCustomTextWithArrowButton(title: I18N.Home.viewAll)
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStackView()
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
            titleStackView,
            viewAllButton
        )
        
        titleStackView.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
        }
        
        viewAllButton.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
        }
    }
    
    private func setStackView() {
        titleStackView.addArrangedSubviews(
            titleLabel
        )
    }
}

// MARK: - Methods

extension HomeDefaultHeaderView {
    func configureView<T: HomeSectionKindProtocol>(sectionKind: T) {
        self.titleLabel.text = sectionKind.title
        self.viewAllButton.isHidden = true
        
        if let memberKind = sectionKind as? HomeForMemberSectionLayoutKind {
            self.viewAllButton.isHidden = (memberKind == .appService) ? true : false
        }
    }
}
