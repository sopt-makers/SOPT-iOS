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

/*
 각각의 출석현황을 나타내는 뷰입니다.
 */

extension AttendanceStepType {
    
    var image: UIImage {
        switch self {
        case .none:
            return DSKitAsset.Assets.opAttendNo.image
        case .check:
            return DSKitAsset.Assets.opAttendYes.image
        case .tardy:
            return DSKitAsset.Assets.opAttendLate.image
        case .done:
            return DSKitAsset.Assets.opAttendDone.image
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .none:
            return DSKitAsset.Colors.gray100.color
        case .check, .tardy, .done:
            return DSKitAsset.Colors.purple40.color
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
        label.setTypoStyle(.Main.caption1)
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
        stepImageView.image = type.image
        if type.shadow {
            stepImageView.layer.applyShadow(
                color: UIColor.init(red: 158, green: 0, blue: 255),
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
            $0.height.equalTo(Metric.stepImageSize)
            $0.width.equalTo(Metric.stepImageSize)
        }
        
        stepStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
