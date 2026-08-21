//
//  AppJamMissionCardCVC.swift
//  StampFeature
//
//  Created by 강윤서 on 12/16/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit
import MDS

final class AppJamMissionCardCVC: UICollectionViewCell {

    // MARK: - UI Components

    private let missionImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = SemanticColor.Bg.Neutral.subtle
        view.layer.cornerRadius = BaseRadius.Base.r12
        view.clipsToBounds = true
        return view
    }()

    private let timeBadge = MDSTag(
        text: "",
        size: .small,
        shape: .rect,
        variant: .default,
        style: .solid
    )

    private let missionTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    private let profileView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DSKitAsset.Assets.icDefaultProfile.image
        imageView.layer.cornerRadius = BaseRadius.Base.r12
        imageView.clipsToBounds = true
        return imageView
    }()

    private let userLabel = UILabel()

    // MARK: - View Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension AppJamMissionCardCVC {
    private func setUI() {
        self.backgroundColor = .clear
    }

    private func setLayout() {
        contentView.addSubviews(missionImageView, missionTitleLabel, profileView, userLabel)
        missionImageView.addSubview(timeBadge)

        missionImageView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.top.equalToSuperview()
            make.height.equalTo(240)
        }

        timeBadge.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(BaseSpacing.Base.s8)
        }

        missionTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(24)
            make.top.equalTo(missionImageView.snp.bottom).offset(BaseSpacing.Base.s8)
        }

        profileView.snp.makeConstraints { make in
            make.top.equalTo(missionTitleLabel.snp.bottom).offset(BaseSpacing.Base.s4)
            make.leading.bottom.equalToSuperview()
            make.size.equalTo(24)
        }

        userLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileView.snp.trailing).offset(BaseSpacing.Base.s4)
            make.centerY.equalTo(profileView.snp.centerY)
        }
    }
}

// MARK: - Methods

extension AppJamMissionCardCVC {
    func configureCell(model: AppJamRankRecentPresentationModel) {
        timeBadge.text = model.relativeTime

        missionTitleLabel.text = model.teamName
        missionTitleLabel.setTypography(Typography.title5, textColor: SemanticColor.Fg.Neutral.bold)

        userLabel.text = model.userName
        userLabel.setTypography(Typography.label4, textColor: SemanticColor.Fg.Neutral.subtle)

        missionImageView.setImage(with: model.imageUrl)

        if !model.userProfileImage.isEmpty {
            profileView.setImage(with: model.userProfileImage)
        }
    }
}
