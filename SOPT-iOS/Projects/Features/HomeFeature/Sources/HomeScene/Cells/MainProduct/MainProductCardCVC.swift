//
//  MainProductCardCVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/24/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import MDS

final class MainProductCardCVC: UICollectionViewCell {
    
    // MARK: - UI Components
        
    private let titleLabel = UILabel().then {
        $0.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.subtle, alignment: .center)
    }
    
    private let logoBackgroundView = UIView().then {
        $0.layer.cornerRadius = BaseRadius.Base.r8
        $0.backgroundColor = SemanticColor.Bg.Neutral.ghost
    }
    
    private let logoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
        
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

extension MainProductCardCVC {
    private func setLayout() {
        self.addSubviews(
            logoBackgroundView, logoImageView, titleLabel
        )
        
        logoBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(logoBackgroundView.snp.width)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.center.equalTo(logoBackgroundView.snp.center)
            make.width.lessThanOrEqualTo(54)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoBackgroundView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension MainProductCardCVC {
    func configureCell(model: ServiceType) {
        self.titleLabel.text = model.title
        self.titleLabel.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.subtle, alignment: .center)
        self.logoImageView.image = model.icon
    }
}
