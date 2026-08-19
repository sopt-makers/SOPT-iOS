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
import MDS

import SnapKit

final class AppJamRankingCVC: UICollectionViewCell {

    // MARK: - UI Components

    private let teamNameLabel = UILabel()

    private let scoreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .trailing
        return stackView
    }()

    private let totalScoreLabel = UILabel()

    private let incrementScoreLabel = UILabel()
    
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
        contentView.backgroundColor = SemanticColor.Bg.Layer.default
        contentView.layer.cornerRadius = BaseRadius.Base.r10
    }
    
    private func setLayout() {
        
        scoreStackView.addArrangedSubviews(totalScoreLabel, incrementScoreLabel)
        
        contentView.addSubviews(teamNameLabel, scoreStackView)
        
        teamNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(BaseSpacing.Base.s12)
            make.top.equalTo(contentView).offset(BaseSpacing.Base.s12)
        }

        scoreStackView.snp.makeConstraints { make in
            make.top.equalTo(teamNameLabel.snp.bottom).offset(BaseSpacing.Base.s14)
            make.trailing.equalToSuperview().inset(BaseSpacing.Base.s16)
            make.bottom.equalToSuperview().inset(BaseSpacing.Base.s8)
        }
    }
}

// MARK: - Methods

extension AppJamRankingCVC {
    func configureCell(model: AppJamRankTodayPresentationModel) {
        teamNameLabel.text = model.teamName
        teamNameLabel.setTypography(Typography.label2, textColor: SemanticColor.Fg.Neutral.bold)

        totalScoreLabel.text = "총 \(model.totalPoints)점"
        totalScoreLabel.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.subtle)

        incrementScoreLabel.text = "+\(model.todayPoints)점"
        incrementScoreLabel.setTypography(Typography.title3, textColor: SemanticColor.Fg.Neutral.bold)
    }
}
