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
import MDS

import Lottie

final class HomeDefaultHeaderView: UICollectionReusableView {
    
    // MARK: - Properties

    private(set) lazy var viewAllContentButtonTap = viewAllContentButton.publisher(for: .touchUpInside)
    private(set) var cancelBag = CancelBag()
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.setTypography(Typography.heading3, textColor: SemanticColor.Fg.Neutral.bold)
    }
    
    // TODO: - mds 이미지 추가 후 변경
    private let fireImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icFire.image
    }

    private let viewAllContentButton = MDSTextButton(
        variant: .default,
        size: .small,
        title: I18N.Home.viewAll,
        icon: MDSIcon.chevronRightOutlined
    )

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cancelBag.cancel()
        self.cancelBag = CancelBag()
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
            make.trailing.lessThanOrEqualTo(viewAllContentButton.snp.leading).offset(-8)
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
        self.titleLabel.setTypography(Typography.heading3, textColor: SemanticColor.Fg.Neutral.bold)
        self.fireImageView.isHidden = !sectionKind.shouldShowFireIcon
        self.viewAllContentButton.isHidden = !sectionKind.shouldShowViewAllContentButton
    }
}
