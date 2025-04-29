//
//  STLevelTenStarView.swift
//  StampFeature
//
//  Created by Jae Hyun Lee on 4/23/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

import SnapKit
import Then

final class STLevelTenStarView: UIView {
    
    // MARK: - UI Components
    
    private let starImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icStar.image.withRenderingMode(.alwaysTemplate)
        $0.tintColor = DSKitAsset.Colors.orange300.color
    }
    
    private let starMultipleTenLabel = UILabel().then {
        $0.text = I18N.MissionList.multipleTen
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
        $0.textColor = DSKitAsset.Colors.white100.color
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray600.color
    }
    
    private let specialMissionLabel = UILabel().then {
        $0.text = I18N.MissionList.specialMission
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
        $0.textColor = DSKitAsset.Colors.orange300.color
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
    }
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setStackView()
        self.setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.stackView.removeAllSubViews()
    }
}

// MARK: - UI & Layout

extension STLevelTenStarView {
    private func setStackView() {
        stackView.addArrangedSubviews(
            starImageView,
            starMultipleTenLabel,
            dividerView,
            specialMissionLabel
        )
    }
    
    private func setLayout() {
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.setCustomSpacing(2, after: starImageView)
        stackView.setCustomSpacing(7, after: starMultipleTenLabel)
        stackView.setCustomSpacing(7, after: dividerView)
        
        starImageView.snp.makeConstraints { make in
            make.size.equalTo(15)
        }
        
        dividerView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(7)
        }
    }
}
