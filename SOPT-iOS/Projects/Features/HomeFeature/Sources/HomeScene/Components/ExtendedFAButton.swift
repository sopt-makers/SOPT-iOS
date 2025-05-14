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
    
    private var buttonType: ExtendedFAButtonType = .expended {
        didSet {
            updateLayout(buttonType)
        }
    }
    
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
    
    private let actionButton = UIButton().then {
        $0.setTitle("미션 보기", for: .normal)
        $0.setTitleColor(DSKitAsset.Colors.white.color, for: .normal)
        $0.titleLabel?.font = DSKitFontFamily.Suit.medium.font(size: 13)
        $0.backgroundColor = DSKitAsset.Colors.black.color
        $0.clipsToBounds = true
    }
    
    private let collapsedTitle = UILabel().then {
        $0.text = "솝탬프"
        $0.textColor = DSKitAsset.Colors.orange800.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 12)
    }
    
    private let collapsedSubTitle = UILabel().then {
        $0.text = "미션 보기"
        $0.textColor = DSKitAsset.Colors.gray900.color
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
    }
    
    private let collapsedRightButton = UIImageView().then {
        $0.image = DSKitAsset.Assets.btnRightChevron.image
    }
    
    // MARK: - Initialization
    
    init(frame: CGRect, buttonType: ExtendedFAButtonType = .expended) {
        self.buttonType = buttonType
        super.init(frame: frame)
        
        setUI()
        setExpendedLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.height / 2
        self.actionButton.layer.cornerRadius = 16
    }
}

// MARK: UI & Layout

extension ExtendedFAButton {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.orange400.color
    }
    
    private func setExpendedLayout() {
        self.removeAllSubviews()
        self.addSubviews(serviceBackgroundView, serviceImageView, subTitle, title, actionButton)
        
        serviceBackgroundView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().inset(13)
            make.size.equalTo(42)
            make.centerY.equalToSuperview()
        }
        
        serviceImageView.snp.remakeConstraints { make in
            make.center.equalTo(serviceBackgroundView.snp.center)
        }
        
        title.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.equalTo(serviceBackgroundView.snp.trailing).offset(8)
        }
        
        subTitle.snp.remakeConstraints { make in
            make.leading.equalTo(title.snp.leading)
            make.top.equalTo(title.snp.bottom).offset(4)
        }
        
        actionButton.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().inset(18)
            make.centerY.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(70)
        }
    }
    
    private func setCollapsedLayout() {
        self.removeAllSubviews()
        self.addSubviews(serviceBackgroundView, serviceImageView, collapsedTitle, collapsedSubTitle, collapsedRightButton)
        
        serviceBackgroundView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().inset(9)
            make.centerY.equalToSuperview()
            make.size.equalTo(35)
        }
        
        serviceImageView.snp.remakeConstraints { make in
            make.center.equalTo(serviceBackgroundView)
        }
        
        collapsedTitle.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalTo(serviceBackgroundView.snp.trailing).offset(6)
        }
        
        collapsedSubTitle.snp.remakeConstraints { make in
            make.leading.equalTo(collapsedTitle)
            make.top.equalTo(collapsedTitle.snp.bottom).offset(1)
        }
        
        collapsedRightButton.snp.remakeConstraints { make in
            make.centerY.equalTo(collapsedSubTitle)
            make.leading.equalTo(collapsedSubTitle.snp.trailing)
            make.size.equalTo(16)
        }
    }
    
    private func updateLayout(_ type: ExtendedFAButtonType) {
        switch type {
        case .expended:
            self.setExpendedLayout()
        case .collapsed:
            self.setCollapsedLayout()
        }
        self.layoutIfNeeded()
    }
}

// MARK: - Methods

extension ExtendedFAButton {
    public func setStyle(_ style: ExtendedFAButtonType) {
        self.buttonType = style
        switch style {
        case .expended:
            self.isUserInteractionEnabled = false
        case .collapsed:
            self.isUserInteractionEnabled = true
        }
    }
}
