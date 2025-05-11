//
//  ExtendedFAButton.swift
//  HomeFeature
//
//  Created by 강윤서 on 5/10/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit

enum ExtendedFAButtonType {
    case expended
    case collapsed
}

final class ExtendedFAButton: UIView {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let serviceBackgroundView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.orange500.color
        $0.layer.cornerRadius = 21
    }
    
    private let serviceImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icBell.image.withRenderingMode(.alwaysOriginal)
    }
    
    private let title = UILabel().then {
        $0.text = "점수 2배! 깜짝 미션 오픈"
        $0.font = DSKitFontFamily.Suit.bold.font(size: 16)
        $0.textColor = DSKitAsset.Colors.gray950.color
    }
    
    private let subTitle = UILabel().then {
        $0.text = "지금 바로 미션에 도전해보세요"
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 12)
        $0.textColor = DSKitAsset.Colors.orange700.color
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
        self.layer.cornerRadius = self.frame.height / 2
    }
}

// MARK: UI & Layout

extension ExtendedFAButton {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.orange400.color
    }
    
    private func setLayout() {
        self.addSubviews(serviceBackgroundView, serviceImageView, subTitle, title)
        
        serviceBackgroundView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(13)
            make.size.equalTo(42)
        }
        
        serviceImageView.snp.makeConstraints { make in
            make.size.equalTo(42)
            make.center.equalTo(serviceBackgroundView.snp.center)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.equalTo(serviceBackgroundView.snp.trailing).offset(8)
        }
        
        subTitle.snp.makeConstraints { make in
            make.leading.equalTo(title.snp.leading)
            make.top.equalTo(title.snp.bottom).offset(4)
        }
    }
}

// MARK: - Methods

extension ExtendedFAButton {
    public func setStyle(_ style: ExtendedFAButtonType) {
        switch style {
        case .expended:
            self.isUserInteractionEnabled = false
        case .collapsed:
            <#code#>
        }
    }
}
