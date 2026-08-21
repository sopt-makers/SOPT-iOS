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
import MDS

// MARK: ClapListCVC

final class ClapListCVC: UICollectionViewCell, UICollectionViewRegisterable {

    // MARK: - Properties

    static var isFromNib: Bool = false
    private var model: ClapperModel?

    // MARK: - UI Components

    private let profileView = MDSAvatar(size: 32, hasStroke: false)

    private let nameLabel = UILabel()

    private let subtitleLabel = UILabel().then {
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 1
    }

    private let clapLabel = UILabel().then {
        $0.textAlignment = .right
    }

    private let clapIcon = UIImageView().then {
        $0.image = MDSIcon.clapDefaultOutlined.image
        $0.tintColor = SemanticColor.Fg.Neutral.bold
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
        nameLabel.setTypography(Typography.title5, textColor: SemanticColor.Fg.Neutral.bold)
        subtitleLabel.text = model.profileMessage
        subtitleLabel.setTypography(Typography.body3, textColor: SemanticColor.Fg.Neutral.subtle)
        clapLabel.text = "\(model.clapCount)회"
        clapLabel.setTypography(Typography.title5, textColor: SemanticColor.Fg.Neutral.bold)

        if !model.profileImageUrl.isEmpty {
            profileView.setImage(with: model.profileImageUrl)
        } else {
            profileView.image = nil
        }
    }
}

extension ClapListCVC {
    private func setUI() {
        contentView.backgroundColor = SemanticColor.Bg.Neutral.ghost
        contentView.layer.cornerRadius = BaseRadius.Base.r8
        contentView.clipsToBounds = true
    }

    private func setLayout() {
        contentView.addSubviews(profileView, nameLabel, subtitleLabel, clapLabel, clapIcon)

        profileView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
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
            $0.top.equalTo(nameLabel.snp.bottom).offset(2)
            $0.trailing.lessThanOrEqualTo(clapLabel.snp.leading).offset(-8)
            $0.bottom.equalToSuperview().offset(-8)
        }

        clapIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(18)
            $0.height.equalTo(20)
        }

        clapLabel.snp.makeConstraints {
            $0.trailing.equalTo(clapIcon.snp.leading).offset(-4)
            $0.centerY.equalToSuperview()
        }
    }
}
