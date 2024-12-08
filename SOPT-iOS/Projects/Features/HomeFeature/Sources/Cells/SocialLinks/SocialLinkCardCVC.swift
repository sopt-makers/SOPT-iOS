//
//  SocialLinkCardCVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/28/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

enum SocialLinkCardType: CaseIterable {
    case homePage
    case instagram
    case youtube
    
    var image: UIImage {
        switch self {
        case .homePage:
            return DSKitAsset.Assets.icHomepage.image
        case .instagram:
            return DSKitAsset.Assets.icInstagram.image
        case .youtube:
            return DSKitAsset.Assets.icYoutube.image
        }
    }
    
    var description: String {
        switch self {
        case .homePage:
            return I18N.Home.SocialLink.homePage
        case .instagram:
            return I18N.Home.SocialLink.instagram
        case .youtube:
            return I18N.Home.SocialLink.youtube
        }
    }
}

final class SocialLinkCardCVC: UICollectionViewCell {
    
    // MARK: - UI Components
        
    private let socialLinkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let socialLinkTitleLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.medium.font(size: 14)
        $0.textColor = DSKitAsset.Colors.gray100.color
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = 8
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStackView()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension SocialLinkCardCVC {
    private func setUI() {
        self.layer.cornerRadius = 8
        self.backgroundColor = DSKitAsset.Colors.gray800.color
    }
    
    private func setLayout() {
        self.addSubview(contentStackView)
        
        socialLinkImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        
        socialLinkTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
        }
    }
    
    private func setStackView() {
        contentStackView.addArrangedSubviews(
            socialLinkImageView,
            socialLinkTitleLabel
        )
    }
}

// MARK: - Methods

extension SocialLinkCardCVC {
    func configureCell(type: SocialLinkCardType) {
        self.socialLinkImageView.image = type.image
        self.socialLinkTitleLabel.text = type.description
    }
}
