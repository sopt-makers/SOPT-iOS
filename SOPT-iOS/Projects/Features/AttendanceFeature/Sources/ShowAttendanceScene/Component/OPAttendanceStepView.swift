//
//  OPAttendanceStepView.swift
//  AttendanceFeature
//
//  Created by 김영인 on 2023/04/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit
import MDS

/*
 오늘의 n차 출석현황 프로그래스 뷰 내부의 단일 출석여부를 나타내는 뷰입니다.
 */

extension AttendanceStepType {

    var image: UIImage {
        switch self {
        case .none:
            return DSKitAsset.Assets.opAttendBefore.image
        case .check:
            return DSKitAsset.Assets.opAttendYes.image
        case .unCheck:
            return DSKitAsset.Assets.opAttendNo.image
        case .tardy:
            return DSKitAsset.Assets.opAttendLate.image
        case .done:
            return DSKitAsset.Assets.opAttendDone.image
        case .absent:
            return DSKitAsset.Assets.opAttendAbsent.image
        }
    }

    var textColor: UIColor {
        switch self {
        case .none:
            return SemanticColor.Fg.Neutral.subtle
        case .check, .unCheck, .tardy, .done, .absent:
            return SemanticColor.Fg.Neutral.bold
        }
    }

    var hasShadow: Bool {
        self != .none
    }
}

final class OPAttendanceStepView: UIView {
    
    private enum Metric {
        static let stepImageSize = 24.f

        static let stackViewWidth = 47.f
    }

    // MARK: - Properties

    private var type: AttendanceStepType
    private var title: String?

    // MARK: - UI Components

    private let stepStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()

    private let stepImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let stepTitleLabel: UILabel = {
        let label = UILabel()
        label.setTypography(Typography.label4)
        return label
    }()
    
    // MARK: - Init
    
    init(step: AttendanceStepModel) {
        self.type = step.type
        self.title = step.title
        
        super.init(frame: .zero)
        
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension OPAttendanceStepView {
    private func setUI() {
        stepTitleLabel.text = title
        stepTitleLabel.setTypography(Typography.label4, textColor: type.textColor)

        stepImageView.image = type.image
        if type.hasShadow {
            stepImageView.layer.applyShadow(
                color: .white,
                alpha: 0.3,
                x: 0,
                y: 0,
                blur: 16,
                spread: 0
            )
        }
    }

    private func setLayout() {
        stepStackView.addArrangedSubviews(
            stepImageView,
            stepTitleLabel
        )

        addSubview(stepStackView)

        stepImageView.snp.makeConstraints {
            $0.size.equalTo(Metric.stepImageSize)
        }

        stepStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
