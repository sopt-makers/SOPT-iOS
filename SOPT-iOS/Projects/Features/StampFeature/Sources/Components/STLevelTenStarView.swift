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
import MDS

import SnapKit
import Then

final class STLevelTenStarView: UIView {

    // MARK: - UI Components

    private let starImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icStar.image.withRenderingMode(.alwaysTemplate)
        $0.tintColor = SemanticColor.Fg.Brand.default
    }

    private let starMultipleTenLabel = UILabel().then {
        $0.text = I18N.MissionList.multipleTen
        $0.setTypography(Typography.label3,
                         textColor: SemanticColor.Fg.Neutral.bold)
    }

    private let dividerView = UIView().then {
        $0.backgroundColor = SemanticColor.Stroke.Neutral.default
    }

    private let specialMissionLabel = UILabel().then {
        $0.text = I18N.MissionList.specialMission
        $0.setTypography(Typography.label3,
                         textColor: SemanticColor.Fg.Brand.default)
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
        stackView.setCustomSpacing(6, after: starMultipleTenLabel)
        stackView.setCustomSpacing(6, after: dividerView)
        
        starImageView.snp.makeConstraints { make in
            make.size.equalTo(15)
        }
        
        dividerView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(7)
        }
    }
}
