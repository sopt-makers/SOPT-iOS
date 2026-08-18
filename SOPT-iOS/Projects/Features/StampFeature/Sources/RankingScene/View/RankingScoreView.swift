//
//  RankingScoreView.swift
//  StampFeature
//
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit

import MDS
import SnapKit
import Then

final class RankingScoreView: UIView {

    // MARK: - UI Components

    private let scoreLabel = UILabel()
    private let unitLabel = UILabel()

    private lazy var contentStackView = UIStackView(arrangedSubviews: [scoreLabel, unitLabel]).then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = BaseSpacing.Base.s2
    }

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

extension RankingScoreView {
    private func setUI() {
        scoreLabel.setTypography(Typography.heading2, textColor: SemanticColor.Fg.Neutral.bold)

        unitLabel.text = "점"
        unitLabel.setTypography(Typography.heading4, textColor: SemanticColor.Fg.Neutral.bold)
    }

    private func setLayout() {
        addSubview(contentStackView)

        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension RankingScoreView {
    func setScore(_ score: String) {
        scoreLabel.text = score
        scoreLabel.setTypography(Typography.heading2, textColor: SemanticColor.Fg.Neutral.bold)
    }
}
