//
//  HomeCustomTextWithArrowButton.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class HomeCustomTextWithArrowButton: UIView {

    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 12)
        $0.textColor = DSKitAsset.Colors.gray300.color
        $0.textAlignment = .center
    }
    
    private let chervronIconImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.chevronRight.image.withTintColor(DSKitAsset.Colors.gray300.color)
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    // MARK: - Initialization

    init(title: String) {
        super.init(frame: .zero)
        setUI(title)
        setStackView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension HomeCustomTextWithArrowButton {
    private func setUI(_ title: String) {
        self.titleLabel.text = title
    }
    
    private func setStackView() {
        self.contentStackView.addArrangedSubviews(
            titleLabel,
            chervronIconImageView
        )
    }
    
    private func setLayout() {
        self.addSubview(self.contentStackView)
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
