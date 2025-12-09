//
//  HomeNotificationBadgeView.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/19/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class HomeNotificationBadgeView: UIView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 12)
        $0.textColor = DSKitAsset.Colors.black.color
        $0.textAlignment = .center
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius()
    }
}


// MARK: - UI & Layout

extension HomeNotificationBadgeView {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.secondary.color
    }
    
    private func setLayout() {
        self.addSubviews(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(6)
            make.top.bottom.equalToSuperview().inset(3)
            make.width.greaterThanOrEqualTo(8)
        }
    }
    
    private func setCornerRadius() {
        self.layer.cornerRadius = self.frame.height / 2
    }
}


// MARK: - Methods

extension HomeNotificationBadgeView {
    func setData(with text: String) {
        self.titleLabel.text = text
    }
}
