//
//  SocialLinkCardCVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/28/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import MDS

final class SocialLinkCardCVC: UICollectionViewCell {
    
    // MARK: - UI Components
        
    private let socialLinkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let socialLinkTitleLabel = UILabel()
    
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
        self.layer.cornerRadius = BaseRadius.Base.r8
        self.backgroundColor = SemanticColor.Bg.Neutral.ghost
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
    func configureCell(type: ServiceType) {
        self.socialLinkImageView.image = type.icon.withTintColor(SemanticColor.Fg.Neutral.default)
        if type == .instagram { // 인스타그램인 경우, 인스타로 축약
            self.socialLinkTitleLabel.text = I18N.Home.SocialLink.instagram
        } else {
            self.socialLinkTitleLabel.text = type.title
        }
        self.socialLinkTitleLabel.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.default)
    }
}
