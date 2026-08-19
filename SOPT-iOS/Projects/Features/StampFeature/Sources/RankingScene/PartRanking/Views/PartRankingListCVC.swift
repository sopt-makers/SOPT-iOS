//
//  PartRankingListCVC.swift
//  StampFeature
//
//  Created by Aiden.lee on 2024/04/01.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain
import MDS

import SnapKit

final class PartRankingListCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    var model: PartRankingModel?
    
    // MARK: - UI Components
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private let partNameLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let scoreView = STRankingScoreView()
    
    // MARK: - View Life Cycles
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layouts

extension PartRankingListCVC {
    
    public func setUI() {
        self.backgroundColor = SemanticColor.Bg.Layer.default
        self.layer.cornerRadius = BaseRadius.Base.r8
    }
    
    private func setLayout() {
        self.addSubviews(rankLabel, partNameLabel, scoreView)

        rankLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16.adjusted)
        }

        partNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(rankLabel.snp.trailing).offset(16.adjusted)
        }

        scoreView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16.adjusted)
        }
    }
}

// MARK: - Methods

extension PartRankingListCVC {
    public func setData(model: PartRankingModel) {
        self.model = model
        rankLabel.text = String(model.rank)
        rankLabel.setTypography(Typography.heading1,
                                textColor: SemanticColor.Fg.Neutral.default)
        partNameLabel.text = model.part
        partNameLabel.setTypography(Typography.title5, textColor: SemanticColor.Fg.Neutral.bold)
        scoreView.setScore(String(format: "%.2f", model.pointsDecimal))
        setDefaultRanking()
    }

    private func setDefaultRanking() {
        self.backgroundColor = SemanticColor.Bg.Layer.default
        self.layer.borderColor = nil
        self.layer.borderWidth = 0
        rankLabel.setTypography(Typography.heading1, textColor: SemanticColor.Fg.Neutral.default)
    }
}
