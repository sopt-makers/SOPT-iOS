//
//  ProfileInfoView.swift
//  StampFeature
//
//  Created by 성현주 on 12/21/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import SnapKit
import Then
import DSKit

public final class ProfileInfoView: UIView {

    // MARK: - UI Components

    private let profileImageView = CustomProfileImageView().hideBorder()
    private let nameLabel = UILabel()
    private let arrowImageView = UIImageView()

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setUI() {
        self.backgroundColor = .clear

        profileImageView.hideBorder()

        nameLabel.font = .SoptampFont.subtitle3
        nameLabel.textColor = DSKitAsset.Colors.white.color
        nameLabel.text = "닉네임"

        arrowImageView.image = DSKitAsset.Assets.icLeftArrow.image
        arrowImageView.tintColor = DSKitAsset.Colors.white.color
        arrowImageView.contentMode = .scaleAspectFit
    }

    private func setLayout() {
        self.addSubviews(profileImageView, nameLabel, arrowImageView)

        profileImageView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.size.equalTo(22)
        }

        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(5)
            $0.centerY.equalToSuperview()
        }

        arrowImageView.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.trailing).offset(2)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        self.snp.makeConstraints {
            $0.height.equalTo(22)
        }
    }
}

extension ProfileInfoView {
    public func configure(name: String, profileImageURL: String? = nil) {
        nameLabel.text = name

        if let imageURL = profileImageURL, !imageURL.isEmpty {
            profileImageView.setImage(with: imageURL)
        } else {
            profileImageView.setPlaceholder()
        }
    }
}
