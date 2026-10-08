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
import MDS

/*
 오늘의 n차 출석현황 프로그래스 뷰 내부의 단일 출석여부를 나타내는 뷰입니다.
 */
// TODO: - 피그마에 결석, 지각 case 추가되면 변경

extension AttendanceStepType {

    var circleFillColor: UIColor {
        switch self {
        case .check, .unCheck:
            return SemanticColor.Bg.Neutral.inverse
        case .none, .tardy, .done, .absent:
            return SemanticColor.Bg.Neutral.subtle
        }
    }

    var circleBorderColor: UIColor {
        switch self {
        case .none, .check, .unCheck:
            return SemanticColor.Stroke.Neutral.default
        case .tardy, .done, .absent:
            return SemanticColor.Stroke.Neutral.inverse
        }
    }

    var icon: UIImage? {
        switch self {
        case .none:
            return nil
        case .check, .done:
            return MDSIcon.checkOutlined.image
        default:
            return nil
        }
    }

    var iconTintColor: UIColor {
        switch self {
        case .none, .check, .unCheck:
            return SemanticColor.Stroke.Neutral.default
        case .tardy, .done, .absent:
            return SemanticColor.Fg.Neutral.bold
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
        static let circleBorderWidth = 1.f
        static let iconSize = 16.f
        static let iconCenterYOffset = 1.f

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

    private let stepCircleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Metric.stepImageSize / 2
        view.layer.borderWidth = Metric.circleBorderWidth
        return view
    }()

    private let stepIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
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
        stepTitleLabel.textColor = type.textColor
        stepTitleLabel.text = title
        stepTitleLabel.setTypography(Typography.label4)

        stepCircleView.backgroundColor = type.circleFillColor
        stepCircleView.layer.borderColor = type.circleBorderColor.cgColor
        stepIconImageView.image = type.icon?.withRenderingMode(.alwaysTemplate)
        stepIconImageView.tintColor = type.iconTintColor
        if type.hasShadow {
            stepCircleView.layer.applyShadow(
                color: .white,
                alpha: 0.25,
                x: 0,
                y: 0,
                blur: 12,
                spread: 0
            )
        }
    }

    private func setLayout() {
        stepCircleView.addSubview(stepIconImageView)

        stepStackView.addArrangedSubviews(
            stepCircleView,
            stepTitleLabel
        )

        addSubview(stepStackView)

        stepCircleView.snp.makeConstraints {
            $0.size.equalTo(Metric.stepImageSize)
        }

        stepIconImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(Metric.iconCenterYOffset)
            $0.width.height.equalTo(Metric.iconSize)
        }

        stepStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
