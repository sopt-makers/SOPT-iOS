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
// TODO: - 피그마에 결석, 지각 case 추가되면 변경

extension AttendanceStepType {

    /// Figma 상 `none`, `check` 상태는 MDS 토큰(원 + 체크 아이콘)으로 그려지고,
    /// 나머지 상태는 디자인이 확정되기 전까지 기존 레거시 이미지 에셋을 그대로 사용합니다.
    var isCircleStyle: Bool {
        switch self {
        case .none, .check:
            return true
        case .unCheck, .tardy, .done, .absent:
            return false
        }
    }

    var circleFillColor: UIColor {
        switch self {
        case .check:
            return .clear
        default:
            return SemanticColor.Bg.Neutral.subtle
        }
    }

    var circleBorderColor: UIColor {
        switch self {
        case .check:
            return SemanticColor.Stroke.Neutral.inverse
        default:
            return SemanticColor.Stroke.Neutral.default
        }
    }

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

    var shadow: Bool {
        switch self {
        case .none:
            return false
        default:
            return true
        }
    }
}

final class OPAttendanceStepView: UIView {
    
    private enum Metric {
        static let stepImageSize = 24.f
        static let circleBorderWidth = 1.5.f
        static let checkIconSize = 16.f

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

    /// 상태별 아이콘을 표시하는 24x24 고정 컨테이너. `.none`/`.check`는 원+체크 아이콘(MDS),
    /// 그 외 상태는 레거시 이미지 에셋을 겹쳐 놓고 하나만 보여줍니다.
    private let stepIconContainerView = UIView()

    private let stepImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let stepCircleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Metric.stepImageSize / 2
        view.layer.borderWidth = Metric.circleBorderWidth
        view.clipsToBounds = true
        return view
    }()

    private let stepCheckImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = MDSIcon.checkOutlined.image
        imageView.tintColor = SemanticColor.Fg.Neutral.bold
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

        if type.isCircleStyle {
            stepImageView.isHidden = true
            stepCircleView.isHidden = false
            stepCircleView.backgroundColor = type.circleFillColor
            stepCircleView.layer.borderColor = type.circleBorderColor.cgColor
            stepCheckImageView.isHidden = type != .check
        } else {
            stepCircleView.isHidden = true
            stepCheckImageView.isHidden = true
            stepImageView.isHidden = false
            stepImageView.image = type.image
            if type.shadow {
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
    }

    private func setLayout() {
        stepCircleView.addSubview(stepCheckImageView)
        stepIconContainerView.addSubviews(stepImageView, stepCircleView)

        stepStackView.addArrangedSubviews(
            stepIconContainerView,
            stepTitleLabel
        )

        addSubview(stepStackView)

        stepIconContainerView.snp.makeConstraints {
            $0.height.equalTo(Metric.stepImageSize)
            $0.width.equalTo(Metric.stepImageSize)
        }

        stepImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        stepCircleView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        stepCheckImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(Metric.checkIconSize)
        }

        stepStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
