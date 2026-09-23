//
//  MyPageProfileCVC.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 2026/06/29.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import SnapKit
import Then

import Core
import MDS

final class MyPageProfileCVC: UICollectionViewCell {

    // MARK: - UI Components
    
    private let profileImageView = MDSAvatar(size: 80, hasStroke: false)

    private let nameLabel = UILabel()

    private let partLabel = UILabel()

    private let profileInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 2
        $0.alignment = .leading
    }

    private let profileRowStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.alignment = .center
    }
    
    private let editProfileButton = MDSActionButton(
        variant: .secondary,
        size: .small,
        title: I18N.MyPage.editProfile
    )

    // MARK: - Properties

    var onEditProfileTap: (() -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        setActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension MyPageProfileCVC {
    private func setUI() {
        backgroundColor = .clear
    }

    private func setLayout() {
        profileInfoStackView.addArrangedSubviews(nameLabel, partLabel)
        profileRowStackView.addArrangedSubviews(profileImageView, profileInfoStackView)

        contentView.addSubviews(profileRowStackView, editProfileButton)

        profileImageView.snp.makeConstraints {
            $0.size.equalTo(80)
        }

        profileRowStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview()
        }

        editProfileButton.snp.makeConstraints {
            $0.top.equalTo(profileRowStackView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(37)
            $0.bottom.equalToSuperview().inset(12)
        }
    }

    private func setActions() {
        editProfileButton.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
    }

    @objc private func editProfileTapped() {
        onEditProfileTap?()
    }
}

// MARK: - Methods

extension MyPageProfileCVC {
    func configure(name: String, part: String, profileImageURL: String?) {
        nameLabel.text = name
        nameLabel.setTypography(Typography.heading3, textColor: SemanticColor.Fg.Neutral.bold)
        partLabel.text = part
        partLabel.setTypography(Typography.label4, textColor: SemanticColor.Fg.Neutral.default)

        if let imageURL = profileImageURL, !imageURL.isEmpty {
            profileImageView.setImage(with: imageURL)
        } else {
            profileImageView.image = nil
        }
    }
}
