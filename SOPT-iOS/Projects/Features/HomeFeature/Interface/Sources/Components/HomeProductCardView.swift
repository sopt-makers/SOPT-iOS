//
//  HomeProductCardView.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/19/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final public class HomeProductCardView: UIView {
    
    // MARK: - UI Components
    
    private let contentView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.medium.font(size: 14)
        $0.textColor = DSKitAsset.Colors.gray200.color
        $0.textAlignment = .center
    }
    
    private let logoBackgroundView = UIView().then {
        $0.layer.cornerRadius = 8.f
        $0.backgroundColor = DSKitAsset.Colors.gray800.color
    }
    
    private let logoImageView = UIImageView()
        
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

extension HomeProductCardView {
    private func setLayout() {
        self.addSubview(self.contentView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubviews(
            logoBackgroundView, logoImageView, titleLabel
        )
        
        logoBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(logoBackgroundView.snp.width)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.center.equalTo(logoBackgroundView.snp.center)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoBackgroundView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension HomeProductCardView {
    @discardableResult
    public func setTitle(with title: String) -> Self {
        self.titleLabel.text = title
        return self
    }
    
    @discardableResult
    public func setImage(with image: UIImage, size: CGSize) -> Self {
        self.logoImageView.image = image
        logoImageView.snp.makeConstraints { make in
            make.width.equalTo(size.width)
            make.height.equalTo(size.height)
        }
        return self
    }
}
