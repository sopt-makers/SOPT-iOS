//
//  MyAttendanceStateView.swift
//  AttendanceFeature
//
//  Created by devxsby on 2023/04/13.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit
import Domain

/*
 나의 출결 현황 스택뷰에 1줄짜리 상태(출석, 1차 세미나, 00월 00일)를 나타내는 테이블뷰 셀입니다.
 */

final class MyAttendanceStateTVC: UITableViewCell {
    
    // MARK: - UI Components
    
    private let stateImageView = UIImageView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = DSKitFontFamily.Suit.semiBold.font(size: 16)
        label.textColor = .white
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .Main.body2
        label.textColor = DSKitAsset.Colors.gray30.color
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
        addSubviews(stateImageView, titleLabel, dateLabel)
        
        stateImageView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.width.equalTo(34)
            $0.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(stateImageView.snp.trailing).offset(8)
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
        
        stateImageView.image = status.image
        titleLabel.text = model.name
        dateLabel.text = model.date
    }
}
