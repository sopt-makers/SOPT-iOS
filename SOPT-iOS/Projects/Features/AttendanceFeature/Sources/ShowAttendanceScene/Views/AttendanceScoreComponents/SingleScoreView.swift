//
//  SingleScoreView.swift
//  AttendanceFeature
//
//  Created by devxsby on 2023/04/13.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import MDS

/*
 (전체: 00회)를 표현하는 단일 영역 뷰입니다. 
 */

final class SingleScoreView: UIView {
    
    // MARK: - UI Components
    
    private let singleScoreTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = SemanticColor.Fg.Neutral.subtle
        return label
    }()
    
    private let singleScoreCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = SemanticColor.Fg.Neutral.bold
        return label
    }()
    
    // MARK: - Initialization

    init(type: AttendanceStateType, count: Int = 0) {
        super.init(frame: .zero)
        setLayout(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension SingleScoreView {
    
    private func setLayout(_ type: AttendanceStateType) {
        
        addSubviews(singleScoreTitleLabel, singleScoreCountLabel)
        
        singleScoreTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }
        
        singleScoreCountLabel.snp.makeConstraints {
            $0.top.equalTo(singleScoreTitleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setDefaultLayout(_ type: AttendanceStateType) {
        updateScoreTypeLabel(type)
    }
    
    private func updateScoreTypeLabel(_ type: AttendanceStateType) {
        singleScoreTitleLabel.text = type.korean
        singleScoreTitleLabel.setTypography(Typography.label4)
    }
}

// MARK: - Methods

extension SingleScoreView {
    
    func setData(_ count: Int, _ type: AttendanceStateType) {
        setDefaultLayout(type)
        singleScoreCountLabel.text = "\(count)회"
        singleScoreCountLabel.setTypography(Typography.label3)
    }
}
