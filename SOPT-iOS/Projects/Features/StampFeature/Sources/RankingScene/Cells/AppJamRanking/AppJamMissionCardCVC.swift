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
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = DSKitAsset.Colors.gray800.color
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = DSKitFontFamily.Suit.semiBold.font(size: 11)
        label.textColor = DSKitAsset.Colors.gray10.color
        label.textAlignment = .center
        return label
    }()
    
    private let teamLabel: UILabel = {
        let label = UILabel()
        label.font = DSKitFontFamily.Suit.medium.font(size: 12)
        label.textColor = DSKitAsset.Colors.gray300.color
        label.textAlignment = .center
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
        contentView.addSubview(containerView)
        containerView.addSubviews(timeLabel, teamLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        teamLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
    }
}

// MARK: - Methods

extension AppJamMissionCardCVC {
    func configureCell(time: String, teamName: String) {
        timeLabel.text = time
        teamLabel.text = teamName
    }
}

