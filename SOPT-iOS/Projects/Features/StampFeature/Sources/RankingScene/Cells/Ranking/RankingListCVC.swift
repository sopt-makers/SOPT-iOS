//
//  RankingListCVC.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain
import MDS

import SnapKit

final class RankingListCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    
    private var model: RankingModel?
    
    // MARK: - UI Components
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private lazy var userSentenceStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
        st.distribution = .fillProportionally
        st.addArrangedSubviews(usernameLabel, sentenceLabel)
        st.spacing = 4
        return st
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.setCharacterSpacing(0)
        return label
    }()

    private let sentenceLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.setCharacterSpacing(0)
        return label
    }()

    private let scoreView = RankingScoreView()
    
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

extension RankingListCVC {
    
    public func setUI() {
        self.backgroundColor = SemanticColor.Bg.Layer.default
        self.layer.cornerRadius = BaseRadius.Base.r8
    }
    
    private func setLayout() {
        self.addSubviews(rankLabel, userSentenceStackView, scoreView)

        rankLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16.adjusted)
            make.width.greaterThanOrEqualTo(53.adjusted)
        }

        userSentenceStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(rankLabel.snp.trailing).offset(16.adjusted)
            make.width.lessThanOrEqualTo(157.adjusted)
        }

        scoreView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16.adjusted)
        }
    }
}

// MARK: - Methods

extension RankingListCVC {
    
    public func setData(model: RankingModel, rank: Int) {
        self.model = model
        rankLabel.text = String(rank)
        usernameLabel.text = model.username
        usernameLabel.setTypography(Typography.title5, textColor: SemanticColor.Fg.Neutral.bold)
        sentenceLabel.text = model.sentence
        sentenceLabel.setTypography(Typography.body2, textColor: SemanticColor.Fg.Neutral.subtle)
        scoreView.setScore(String(model.score))

        return model.isMyRanking
        ? setMyRanking()
        : setDefaultRanking()
    }

    private func setMyRanking() {
        self.backgroundColor = SemanticColor.Bg.Neutral.ghost
        rankLabel.setTypography(Typography.heading1, textColor: SemanticColor.Fg.Neutral.bold)
    }

    private func setDefaultRanking() {
        self.backgroundColor = SemanticColor.Bg.Layer.default
        rankLabel.setTypography(Typography.heading1, textColor: SemanticColor.Fg.Neutral.default)
    }
}

extension RankingListCVC: RankingListTappable {
    func getModelItem() -> RankingListTapItem? {
        guard let model else { return nil }
        return RankingListTapItem.init(username: model.username,
                                       sentence: model.sentence)
    }
}
