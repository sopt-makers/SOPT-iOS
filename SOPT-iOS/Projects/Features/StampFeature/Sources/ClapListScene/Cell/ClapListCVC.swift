//
//  ClapListCVC.swift
//  StampFeature
//
//  Created by 성현주 on 10/22/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain
import DSKit

// MARK: ClapListCVC

final class ClapListCVC: UICollectionViewCell, UICollectionViewRegisterable {

    // MARK: - Properties

    static var isFromNib: Bool = false
    private var model: ClapperModel?

    // MARK: - UI Components

    private let profileView = CustomProfileImageView().hideBorder()

    private let nameLabel = UILabel().then {
        $0.font = .SoptampFont.subtitle1
        $0.textColor = DSKitAsset.Colors.white.color
    }

    private let subtitleLabel = UILabel().then {
        $0.font = .SoptampFont.caption1
        $0.textColor = DSKitAsset.Colors.gray200.color
        $0.lineBreakMode = .byTruncatingTail
    }

    private let clapLabel = UILabel().then {
        $0.font = .SoptampFont.h3
        $0.textColor = DSKitAsset.Colors.white.color
        $0.textAlignment = .right
    }

    private let clapIcon = UIImageView().then {
        $0.image = DSKitAsset.Assets.icClap.image
        $0.tintColor = DSKitAsset.Colors.white.color
        $0.contentMode = .scaleAspectFit
    }

    // MARK: - View Life Cycles

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure

    func setData(model: ClapperModel) {
        self.model = model
        nameLabel.text = model.nickname
        subtitleLabel.text = model.profileMessage
        clapLabel.text = "\(model.clapCount)회"

        if !model.profileImageUrl.isEmpty {
            profileView.setImage(
                with: model.profileImageUrl,
                placeholder: DSKitAsset.Assets.icLineProfile.image
            )
        } else {
            profileView.image = DSKitAsset.Assets.icLineProfile.image
        }
    }
}

extension ClapListCVC {
    private func setUI() {
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
    }

    private func setLayout() {
        contentView.addSubviews(profileView, nameLabel, subtitleLabel, clapLabel, clapIcon)

        profileView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(32)
        }

        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileView.snp.trailing).offset(12)
            $0.top.equalToSuperview().offset(8)
            $0.trailing.lessThanOrEqualTo(clapLabel.snp.leading).offset(-8)
        }

        subtitleLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.trailing.lessThanOrEqualTo(clapLabel.snp.leading).offset(-8)
            $0.bottom.equalToSuperview().offset(-14)
        }

        clapIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        clapLabel.snp.makeConstraints {
            $0.trailing.equalTo(clapIcon.snp.leading).offset(-6)
            $0.centerY.equalToSuperview()
        }
    }
}
