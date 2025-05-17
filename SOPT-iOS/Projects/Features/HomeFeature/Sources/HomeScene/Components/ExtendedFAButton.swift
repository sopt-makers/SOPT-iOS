//
//  ExtendedFAButton.swift
//  HomeFeature
//
//  Created by 강윤서 on 5/10/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import DSKit

final class HomeFAButton: UIView {

    // MARK: - Properties
    public lazy var actionButtonTapped = actionButton.gesture().mapVoid().asDriver()
    private var buttonType: ExtendedFAButtonType = .extended {
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
    
    private let collapsedRightChevronImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.btnRightChevron.image
    }
    
    // MARK: - Initialization
    
    init(frame: CGRect, buttonType: ExtendedFAButtonType = .extended) {
        self.buttonType = buttonType
        super.init(frame: frame)
        
        setUI()
        setExpendedLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonHeight = self.bounds.height
        self.layer.cornerRadius = buttonHeight / 2
        
        self.actionButton.layer.cornerRadius = 16
        
        let backgroundHeight = self.serviceBackgroundView.bounds.height
        self.serviceBackgroundView.layer.cornerRadius = backgroundHeight / 2
    }
}

// MARK: UI & Layout

extension HomeFAButton {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.orange400.color
        self.layer.applyShadow(color: DSKitAsset.Colors.shadow.color, alpha: 0.7, y: 4, blur: 40)
    }
    
    private func setExpendedLayout() {
        self.addSubviews(serviceBackgroundView, serviceImageView, subTitle, title, actionButton)
        
        serviceBackgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(13)
            make.size.equalTo(42)
            make.centerY.equalToSuperview()
        }
        
        serviceImageView.snp.makeConstraints { make in
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
        
        actionButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(18)
            make.width.equalTo(70)
        }
    }
    
    private func setCollapsedLayout() {
        self.addSubviews(serviceBackgroundView, serviceImageView, collapsedTitle, collapsedSubTitle, collapsedRightChevronImageView)
        
        serviceBackgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(9)
            make.centerY.equalToSuperview()
            make.size.equalTo(35)
        }
        
        serviceImageView.snp.makeConstraints { make in
            make.center.equalTo(serviceBackgroundView)
        }
        
        collapsedTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalTo(serviceBackgroundView.snp.trailing).offset(6)
        }
        
        collapsedSubTitle.snp.makeConstraints { make in
            make.leading.equalTo(collapsedTitle)
            make.top.equalTo(collapsedTitle.snp.bottom).offset(1)
        }
        
        collapsedRightChevronImageView.snp.makeConstraints { make in
            make.centerY.equalTo(collapsedSubTitle)
            make.leading.equalTo(collapsedSubTitle.snp.trailing)
            make.size.equalTo(16)
        }
    }
    
    private func updateLayout(_ type: ExtendedFAButtonType) {
        removeAllConstrains()
        
        switch type {
        case .extended:
            self.setExpendedLayout()
        case .collapsed:
            self.setCollapsedLayout()
        }
    }
    
    private func removeAllConstrains() {
        self.snp.removeConstraints()
        self.subviews.forEach {
            $0.snp.removeConstraints()
            $0.removeFromSuperview()
        }
    }
}

// MARK: - Methods

extension HomeFAButton {
    public func setStyle(_ style: ExtendedFAButtonType) {
        self.buttonType = style
    }
}
