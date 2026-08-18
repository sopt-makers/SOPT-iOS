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
import MDS

public final class ProfileInfoView: UIView {

    // MARK: - UI Components

    private let profileImageView = CustomProfileImageView().hideBorder()
    private lazy var nameButton = MDSTextButton(
        variant: .emphasis,
        size: .medium,
        title: "닉네임",
        icon: MDSIcon.chevronRightOutlined
    )

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
    }

    private func setLayout() {
        self.addSubviews(profileImageView, nameButton)

        profileImageView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.size.equalTo(22)
        }

        nameButton.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(5)
            $0.centerY.equalToSuperview()
        }

        self.snp.makeConstraints {
            $0.height.equalTo(22)
        }
    }
}

extension ProfileInfoView {
    public func configure(name: String, profileImageURL: String? = nil) {
        nameButton.title = name

        if let imageURL = profileImageURL, !imageURL.isEmpty {
            profileImageView.setImage(with: imageURL)
        } else {
            profileImageView.setPlaceholder()
        }
    }
}
