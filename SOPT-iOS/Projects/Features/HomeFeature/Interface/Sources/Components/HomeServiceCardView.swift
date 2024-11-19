//
//  HomeServiceCardView.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final public class HomeServiceCardView: UIView {
    
    // MARK: - UI Components
    
    private let contentView = UIView()
    
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
    
    private lazy var notificationBadgeView = HomeNotificationBadgeView()
    
    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension HomeServiceCardView {
    private func setLayout() {
        self.addSubview(self.contentView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubviews(
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

extension HomeServiceCardView {
    func setData(imageURL: String, title: String, badgeText: String) {
        self.logoImageView.setImage(with: imageURL)
        self.titleLabel.text = title
        self.notificationBadgeView.setData(with: badgeText)
    }
}
