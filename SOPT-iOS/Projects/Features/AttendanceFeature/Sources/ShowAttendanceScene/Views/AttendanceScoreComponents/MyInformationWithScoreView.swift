//
//  MyInformationWithScoreView.swift
//  AttendanceFeature
//
//  Created by devxsby on 2023/04/13.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import MDS

/*
 상단 이름, 현재 출석 점수이 있는 뷰입니다.
 */

final class MyInformationWithScoreView: UIView {
    
    // MARK: - UI Components
    
    private let nameLabel = UILabel()
    
    private let currentScoreLabel = UILabel()

    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = SemanticColor.Fg.Neutral.bold
        button.setImage(MDSIcon.alertCircleOutlined.image, for: .normal)
        button.addTarget(self, action: #selector(infoButtonDidTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Properties

    var onInfoButtonTap: (() -> Void)?

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension MyInformationWithScoreView {
    
    private func setLayout() {
        
        addSubviews(nameLabel, currentScoreLabel, infoButton)

        nameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }

        currentScoreLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(14)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        infoButton.snp.makeConstraints {
            $0.centerY.equalTo(currentScoreLabel)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(22)
        }
    }
}

// MARK: - Methods

extension MyInformationWithScoreView {
    
    func setData(name: String, part: String, generation: Int, count: Double) {
        nameLabel.text = "\(generation)기 \(part) \(name)"
        nameLabel.setTypography(Typography.title5, textColor: SemanticColor.Fg.Neutral.subtle)
        
        chageFontAndColor(with: "\(doubleToString(count))점")
    }
    
    private func chageFontAndColor(with pointedText: String) {
        let mainText = I18N.Attendance.currentAttendanceScore
        let subText = I18N.Attendance.scoreIs
        
        let attributedString = NSMutableAttributedString(string: mainText + pointedText + subText)

        attributedString.addAttributes(
            Typography.title4.attributedStringAttributes(foregroundColor: SemanticColor.Fg.Neutral.bold),
            range: NSRange(location: 0, length: mainText.count)
        )

        attributedString.addAttributes(
            Typography.title4.attributedStringAttributes(foregroundColor: SemanticColor.Fg.Brand.default),
            range: NSRange(location: mainText.count, length: pointedText.count)
        )

        attributedString.addAttributes(
            Typography.title4.attributedStringAttributes(foregroundColor: SemanticColor.Fg.Neutral.bold),
            range: NSRange(location: mainText.count + pointedText.count, length: subText.count)
        )
        
        currentScoreLabel.attributedText = attributedString
    }
    
    @objc
    private func infoButtonDidTap() {
        onInfoButtonTap?()
    }

    private func doubleToString(_ number: Double) -> String {
        if number.truncatingRemainder(dividingBy: 1) == 0 {
            return(String(format: "%.0f", number))
        } else {
            return(String(format: "%.1f", number))
        }
    }
}
