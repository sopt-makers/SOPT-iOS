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
    private var model: ClapListModel?

    // MARK: - UI Components

    private let profileView = UIView().then {
        //TODO: - 실제 이미지뷰로 변경해주세요.
        $0.backgroundColor = DSKitAsset.Colors.gray700.color
        $0.layer.cornerRadius = 16
    }

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
        //TODO: - 실제 박수 icon으로 변경해주세요.
        $0.image = UIImage(systemName: "hand.wave.fill")
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

    func setData(model: ClapListModel) {
        nameLabel.text = model.nickname
        subtitleLabel.text = model.profileMessage
        clapLabel.text = "\(model.clapCount)회"
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
            $0.leading.equalToSuperview().offset(12)
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
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        clapLabel.snp.makeConstraints {
            $0.trailing.equalTo(clapIcon.snp.leading).offset(-6)
            $0.centerY.equalToSuperview()
        }
    }
}
