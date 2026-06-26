//
//  AppJamRankingCVC.swift
//  StampFeature
//
//  Created by 강윤서 on 12/16/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

import SnapKit

final class AppJamRankingCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var rank: Int = 1
    
    // MARK: - UI Components
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = DSKitFontFamily.Suit.bold.font(size: 16)
        label.textColor = DSKitAsset.Colors.white.color
        return label
    }()
    
    private let teamNameLabel: UILabel = {
        let label = UILabel()
        label.font = DSKitFontFamily.Suit.bold.font(size: 16)
        label.textColor = DSKitAsset.Colors.white.color
        return label
    }()
    
    private let scoreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .trailing
        return stackView
    }()
    
    private let totalScoreLabel: UILabel = {
        let label = UILabel()
        label.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
        label.textColor = DSKitAsset.Colors.gray300.color
        return label
    }()
    
    private let incrementScoreLabel: UILabel = {
        let label = UILabel()
        label.font = DSKitFontFamily.Suit.bold.font(size: 20)
        label.textColor = DSKitAsset.Colors.white.color
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

extension AppJamRankingCVC {
    private func setUI() {
        contentView.backgroundColor = DSKitAsset.Colors.gray900.color
        contentView.layer.cornerRadius = 10
    }
    
    private func setLayout() {
        
        scoreStackView.addArrangedSubviews(totalScoreLabel, incrementScoreLabel)
        
        contentView.addSubviews(teamNameLabel, scoreStackView)
        
        teamNameLabel.snp.makeConstraints { make in            
            make.leading.equalTo(contentView).offset(12)
            make.top.equalTo(contentView).offset(12)
        }
        
        scoreStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
        }
        
        totalScoreLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        incrementScoreLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
    }
}

// MARK: - Methods

extension AppJamRankingCVC {
    func configureCell(model: AppJamRankTodayPresentationModel) {
        self.rank = model.rank
        
        rankLabel.text = "\(model.rank)"
        teamNameLabel.text = model.teamName
        totalScoreLabel.text = "총 \(model.totalPoints)점"
        incrementScoreLabel.text = "+\(model.todayPoints)점"
    }
}
