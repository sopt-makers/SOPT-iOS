//
//  MyAttendanceStateView.swift
//  AttendanceFeature
//
//  Created by devxsby on 2023/04/13.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import MDS

import Domain

/*
 나의 출결 현황 스택뷰에 1줄짜리 상태(출석, 1차 세미나, 00월 00일)를 나타내는 테이블뷰 셀입니다.
 */

final class MyAttendanceStateTVC: UITableViewCell {
    
    // MARK: - UI Components
    
    // TODO: - MDSTag 변경 후 적용
//    private let stateTag: MDSTag = {
//        let tag = MDSTag(text: "", size: .small, shape: .rect, variant: .default, style: .solid)
//        return tag
//    }()
    private let stateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = BaseRadius.Base.r4
        label.layer.masksToBounds = true
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = SemanticColor.Fg.Neutral.bold
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = SemanticColor.Fg.Neutral.subtle
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension MyAttendanceStateTVC {
    
    private func setUI() {
        backgroundColor = .clear
    }
    
    private func setLayout() {
        addSubviews(stateLabel, titleLabel, dateLabel)
        
        stateLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.width.equalTo(34)
            $0.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(stateLabel.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension MyAttendanceStateTVC {
    
    func setData(model: AttendanceModel) {
        guard let status = AttendanceStateType(rawValue: model.status.lowercased()) else { return }
        
        stateLabel.text = status.korean
        stateLabel.backgroundColor = status.tagBackgroundColor
        stateLabel.setTypography(Typography.label4, textColor: status.tagTextColor)
        
        titleLabel.text = model.name
        titleLabel.setTypography(Typography.label3)
        
        dateLabel.text = model.date
        dateLabel.setTypography(Typography.label4)
    }
}
