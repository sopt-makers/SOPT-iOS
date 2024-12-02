//
//  CoffeeChatRoundTagCVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/28/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class CoffeeChatRoundTagCVC: UICollectionViewCell {

    // MARK: - UI Components

    private let titleLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 11)
        $0.textColor = DSKitAsset.Colors.gray200.color
        $0.textAlignment = .center
    }
    
    private let titleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 4
    }
    
    private let activityRoundView = UIView().then {
        $0.layer.cornerRadius = 3
        $0.backgroundColor = DSKitAsset.Colors.secondary.color
        $0.isHidden = true
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        setStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension CoffeeChatRoundTagCVC {
    private func setUI() {
        self.layer.cornerRadius = 4.f
    }
    
    private func setLayout() {
        self.addSubviews(titleStackView)
        
        activityRoundView.snp.makeConstraints { make in
            make.size.equalTo(6)
        }
        
        titleStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
    
    private func setStackView() {
        titleStackView.addArrangedSubviews(
            activityRoundView,
            titleLabel
        )
    }
}

// MARK: - Methods

extension CoffeeChatRoundTagCVC {
    func setData(info: GenerationTagInfo) {
        self.titleLabel.text = info.title
        if info.isActive {
            activityRoundView.isHidden = false
            self.titleLabel.textColor = CoffeeChatGenerationHistoryTagType.currentActivity.titleColor
            self.backgroundColor = CoffeeChatGenerationHistoryTagType.currentActivity.backgroundColor
        } else {
            self.titleLabel.textColor = CoffeeChatGenerationHistoryTagType.pastActivity.titleColor
            self.backgroundColor = CoffeeChatGenerationHistoryTagType.pastActivity.backgroundColor
        }
    }
}

