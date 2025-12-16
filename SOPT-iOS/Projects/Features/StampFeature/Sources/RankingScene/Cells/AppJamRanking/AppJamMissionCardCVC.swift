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

import SnapKit

final class AppJamMissionCardCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let missionImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = DSKitAsset.Colors.gray700.color
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let timeBadgeView: UIView = {
        let view = UIView()
        view.backgroundColor = DSKitAsset.Colors.alpha100.color
        view.layer.cornerRadius = 6
        return view
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = DSKitFontFamily.Suit.semiBold.font(size: 11)
        label.textColor = DSKitAsset.Colors.gray10.color
        return label
    }()
    
    private let missionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = DSKitFontFamily.Suit.bold.font(size: 16)
        label.textColor = DSKitAsset.Colors.white.color
        label.numberOfLines = 0
        return label
    }()
    
    private let profileView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DSKitAsset.Assets.icDefaultProfile.image
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let userLabel: UILabel = {
        let label = UILabel()
        label.font = DSKitFontFamily.Suit.semiBold.font(size: 12)
        label.textColor = DSKitAsset.Colors.gray300.color
        return label
    }()
    
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
        missionImageView.addSubviews(timeBadgeView)
        timeBadgeView.addSubview(timeLabel)
        
        missionImageView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.top.equalToSuperview()
            make.height.equalTo(232)
        }
        
        timeBadgeView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(3.5)
            make.leading.trailing.equalToSuperview().inset(4)
        }
        
        missionTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(24)
            make.top.equalTo(missionImageView.snp.bottom).offset(8)
        }
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(missionTitleLabel.snp.bottom).offset(4)
            make.leading.bottom.equalToSuperview()
            make.size.equalTo(20)
        }
        
        userLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileView.snp.trailing).offset(4)
            make.centerY.equalTo(profileView.snp.centerY)
        }
    }
}

// MARK: - Methods

extension AppJamMissionCardCVC {
    func configureCell(
        missionImage: String,
        time: String,
        missionTitle: String,
        userName: String,
        profileImage: String? = nil
        
    ) {
        timeLabel.text = time
        missionTitleLabel.text = missionTitle
        userLabel.text = userName
        missionImageView.setImage(with: missionImage)
        
        if let profileURL = profileImage {
            profileView.setImage(with: profileURL)
        }
    }
}

