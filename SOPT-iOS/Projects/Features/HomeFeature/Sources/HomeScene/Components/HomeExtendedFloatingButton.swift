//
//  HomeFloatingButton.swift
//  HomeFeature
//
//  Created by 강윤서 on 5/10/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import DSKit

final class HomeFloatingButton: UIView {

    // MARK: - Properties
    public lazy var actionButtonTapped = actionButton.gesture().mapVoid().asDriver()
    private var buttonType: ExtendedFloatingButtonType = .extended {
        didSet {
            updateLayout(buttonType)
        }
    }
    
    // MARK: - UI Components
    
    private let serviceBackgroundView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.orange500.color
        $0.layer.cornerRadius = 21
    }
    
    private let serviceImageView = UIImageView()
    
    private let extendedTitle = UILabel().then {
        $0.font = DSKitFontFamily.Suit.bold.font(size: 16)
        $0.textColor = DSKitAsset.Colors.gray950.color
    }
    
    private let extendedSubTitle = UILabel().then {
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 12)
        $0.textColor = DSKitAsset.Colors.orange700.color
    }
    
    private let actionButton = UIButton().then {
        $0.setTitleColor(DSKitAsset.Colors.white.color, for: .normal)
        $0.titleLabel?.font = DSKitFontFamily.Suit.medium.font(size: 13)
        $0.backgroundColor = DSKitAsset.Colors.black.color
        $0.clipsToBounds = true
    }
    
    private let collapsedTitle = UILabel().then {
        $0.textColor = DSKitAsset.Colors.orange800.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 12)
    }
    
    private let collapsedSubTitle = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray900.color
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
    }
    
    private let collapsedRightChevronImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.btnRightChevron.image
    }
    
    // MARK: - Initialization
    
    init(frame: CGRect, buttonType: ExtendedFloatingButtonType = .extended) {
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

extension HomeFloatingButton {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.orange400.color
        self.layer.applyShadow(color: DSKitAsset.Colors.shadow.color, alpha: 0.7, y: 4, blur: 40)
    }
    
    private func setExpendedLayout() {
        self.addSubviews(serviceBackgroundView, serviceImageView, extendedSubTitle, extendedTitle, actionButton)
        
        serviceBackgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(13)
            make.size.equalTo(42)
            make.centerY.equalToSuperview()
        }
        
        serviceImageView.snp.makeConstraints { make in
            make.center.equalTo(serviceBackgroundView.snp.center)
            make.leading.trailing.equalTo(serviceBackgroundView).inset(6)
        }
        
        extendedTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.equalTo(serviceBackgroundView.snp.trailing).offset(8)
        }
        
        extendedSubTitle.snp.makeConstraints { make in
            make.leading.equalTo(extendedTitle.snp.leading)
            make.top.equalTo(extendedTitle.snp.bottom).offset(4)
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
            make.leading.trailing.equalTo(serviceBackgroundView).inset(5)
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
    
    private func updateLayout(_ type: ExtendedFloatingButtonType) {
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

extension HomeFloatingButton {
    public func setStyle(_ style: ExtendedFloatingButtonType) {
        self.buttonType = style
    }
    
    func configureUI(with model: HomeFloatingButtonPresentationModel) {
        // 공통 속성
        serviceImageView.setImage(with: model.imageUrl)
        
        // 확장 버튼 속성
        extendedTitle.text = model.extenedFloatingButton.title
        extendedSubTitle.text = model.extenedFloatingButton.subTitle
        actionButton.setTitle(model.actionButtonName, for: .normal)
        
        // 접힘 버튼 속성
        collapsedTitle.text = model.collapsedFloatingButton.subTitle
        collapsedSubTitle.text = model.actionButtonName
    }
}
