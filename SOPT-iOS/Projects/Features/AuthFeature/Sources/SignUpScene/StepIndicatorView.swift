//
//  StepIndicatorView.swift
//  AuthFeature
//
//  Created by yungu0010 on 8/7/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import MDS

import SnapKit
import Then

final class StepIndicatorView: UIView {

    // MARK: - UI Components

    let circleView = UIView().then {
        $0.layer.cornerRadius = 11
    }

    private let numberLabel = UILabel().then {
        $0.textAlignment = .center
    }

    let titleLabel = UILabel().then {
        $0.textAlignment = .center
    }

    // MARK: - Init

    init(
        number: String,
        title: String,
        circleTextColor: UIColor,
        circleBackgroundColor: UIColor,
        titleTextColor: UIColor
    ) {
        super.init(frame: .zero)
        numberLabel.text = number
        numberLabel.setTypography(Typography.label4, textColor: circleTextColor)
        circleView.backgroundColor = circleBackgroundColor
        titleLabel.text = title
        titleLabel.setTypography(Typography.label4, textColor: titleTextColor)
        setLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Methods

extension StepIndicatorView {
    private func setLayout() {
        self.addSubviews(circleView, titleLabel)
        circleView.addSubview(numberLabel)

        circleView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(22)
        }
        numberLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(circleView.snp.bottom).offset(BaseSpacing.Base.s12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    func setCircleBackgroundColor(_ color: UIColor) {
        circleView.backgroundColor = color
    }

    func setTitleActive(_ isActive: Bool) {
        titleLabel.setTypography(Typography.label4,
                                 textColor: isActive ? SemanticColor.Fg.Neutral.bold : SemanticColor.Fg.Neutral.ghost)
    }
}
