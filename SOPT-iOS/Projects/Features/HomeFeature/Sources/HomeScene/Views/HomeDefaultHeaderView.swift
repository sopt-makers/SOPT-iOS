//
//  HomeDefaultHeaderView.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

import Lottie

final class HomeDefaultHeaderView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.bold.font(size: 20)
        $0.textColor = DSKitAsset.Colors.white.color
    }
    
    private let fireImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icFire.image
    }
    
    private let viewAllContentButton = UIButton(configuration: .plain()).then {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = DSKitAsset.Colors.gray300.color
        config.contentInsets = .zero
        var attributedTitle = AttributedString(I18N.Home.viewAll)
        attributedTitle.font = DSKitFontFamily.Suit.semiBold.font(size: 12)
        config.attributedTitle = attributedTitle
        let chervonRightImage = DSKitAsset.Assets.iconChevronRight.image.withTintColor(DSKitAsset.Colors.gray300.color)
        config.image = chervonRightImage
        config.imagePlacement = .trailing
        $0.configuration = config
    }

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.titleLabel.snp.removeConstraints()
    }
}

// MARK: - UI & Layout

extension HomeDefaultHeaderView {
    private func setLayout() {
        self.clipsToBounds = true
        
        self.addSubviews(titleLabel, fireImageView, viewAllContentButton)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        fireImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(3)
        }
        
        viewAllContentButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(16)
        }
        
        hiddenFireIcon()
        hiddenViewAllContentButton()
    }
    
    /// 기본적으로 fire 아이콘은 hidden 처리
    private func hiddenFireIcon() {
        self.fireImageView.isHidden = true
    }
    
    /// 기본적으로 전체보기 버튼은 hidden 처리
    private func hiddenViewAllContentButton() {
        self.viewAllContentButton.isHidden = true
    }
}

// MARK: - Methods

extension HomeDefaultHeaderView {
    func configureView(sectionKind: some HomeSectionUIConfigurable) {
        self.titleLabel.text = sectionKind.headerTitle
        self.fireImageView.isHidden = !sectionKind.shouldShowFireIcon
        self.viewAllContentButton.isHidden = !sectionKind.shouldShowViewAllContentButton
    }
}
