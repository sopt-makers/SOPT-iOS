//
//  AppServiceCardCVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import MDS

final class AppServiceCardCVC: UICollectionViewCell {
    
    // MARK: - UI Components
        
    private let titleLabel = UILabel().then {
        $0.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.subtle, alignment: .center)
    }
    
    private let logoBackgroundView = UIView().then {
        $0.layer.cornerRadius = 40.f
        $0.backgroundColor = SemanticColor.Bg.Neutral.ghost
    }
    
    private let logoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let notificationBadgeView = MDSTag(
        text: "",
        size: .small,
        shape: .pill,
        variant: .primary,
        style: .solid
    )
    
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

extension AppServiceCardCVC {
    private func setLayout() {
        self.addSubviews(
            logoBackgroundView, logoImageView, titleLabel, notificationBadgeView
        )
        
        logoBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(logoBackgroundView.snp.width)
        }
        
        notificationBadgeView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.center.equalTo(logoBackgroundView.snp.center)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoBackgroundView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension AppServiceCardCVC {
    func configureCell(model: HomePresentationModel.AppService) {
        self.logoImageView.setImage(with: model.iconURL)
        self.titleLabel.text = model.serviceName
        if model.displayAlarmBadge && !model.alarmBadge.isEmpty {
            self.notificationBadgeView.text = model.alarmBadge
        } else {
            self.notificationBadgeView.isHidden = true
        }
    }
}
