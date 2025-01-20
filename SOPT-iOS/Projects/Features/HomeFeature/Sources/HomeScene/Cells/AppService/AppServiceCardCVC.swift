//
//  AppServiceCardCVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit
import Domain

final class AppServiceCardCVC: UICollectionViewCell {
    
    // MARK: - UI Components
        
    private let titleLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.medium.font(size: 14)
        $0.textColor = DSKitAsset.Colors.gray200.color
        $0.textAlignment = .center
    }
    
    private let logoBackgroundView = UIView().then {
        $0.layer.cornerRadius = 40.f
        $0.backgroundColor = DSKitAsset.Colors.gray800.color
    }
    
    private let logoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let notificationBadgeView = HomeNotificationBadgeView()
    
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
            make.height.equalTo(logoImageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoBackgroundView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension AppServiceCardCVC {
    func configureCell(model: HomeAppServicesModel?) {
        guard let model else { return }
        
        self.logoImageView.setImage(with: model.iconURL)
        self.titleLabel.text = model.serviceName
        if model.alarmBadge.isEmpty {
            self.notificationBadgeView.isHidden = true
        } else {
            self.notificationBadgeView.setData(with: model.alarmBadge)
        }
    }
}
