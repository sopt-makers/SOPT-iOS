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
    public var model: ClapListModel?

    // MARK: - UI Components

    private let profileView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray700.color
        $0.layer.cornerRadius = 20
    }

    private let nameLabel = UILabel().then {
        $0.font = .SoptampFont.h3
        $0.textColor = DSKitAsset.Colors.white.color
    }

    private let subtitleLabel = UILabel().then {
        $0.font = .SoptampFont.subtitle2
        $0.textColor = DSKitAsset.Colors.gray400.color
        $0.lineBreakMode = .byTruncatingTail
    }

    private let clapLabel = UILabel().then {
        $0.font = .SoptampFont.h3
        $0.textColor = DSKitAsset.Colors.white.color
        $0.textAlignment = .right
    }

    private let clapIcon = UIImageView().then {
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

    private func setUI() {
        contentView.backgroundColor = DSKitAsset.Colors.gray900.color
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
    }

    private func setLayout() {
        contentView.addSubviews(profileView, nameLabel, subtitleLabel, clapLabel, clapIcon)

        profileView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(40)
        }

        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileView.snp.trailing).offset(12)
            $0.top.equalToSuperview().offset(14)
            $0.trailing.lessThanOrEqualTo(clapLabel.snp.leading).offset(-8)
        }

        subtitleLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.trailing.lessThanOrEqualTo(clapLabel.snp.leading).offset(-8)
            $0.bottom.equalToSuperview().offset(-14)
        }

        clapLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }

        clapIcon.snp.makeConstraints {
            $0.trailing.equalTo(clapLabel.snp.leading).offset(-4)
            $0.centerY.equalTo(clapLabel)
            $0.size.equalTo(18)
        }
    }

    // MARK: - Configure

    func setData(model: ClapListModel) {
        nameLabel.text = model.name
        subtitleLabel.text = model.subtitle
        clapLabel.text = "\(model.clapCount)회"
    }
}
