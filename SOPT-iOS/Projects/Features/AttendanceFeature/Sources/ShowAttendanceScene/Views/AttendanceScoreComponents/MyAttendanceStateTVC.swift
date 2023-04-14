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

/*
 나의 출결 현황 스택뷰에 1줄짜리 상태(출석, 1차 세미나, 00월 00일)를 나타내는 테이블뷰 셀입니다.
 */

final class MyAttendanceStateTVC: UITableViewCell {
    
    // MARK: - UI Components

    private let attendanceStateButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "1차 세미나"
        configuration.baseForegroundColor = .white
        configuration.attributedTitle?.font = DSKitFontFamily.Suit.bold.font(size: 15)
        configuration.image = DSKitAsset.Assets.opStateAttendance.image
        configuration.imagePadding = 10
        configuration.titleAlignment = .leading
        let button = UIButton(configuration: configuration)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let attendanceStateDateLabel: UILabel = {
        let label = UILabel()
        label.font = .Main.body2
        label.text = "00월 00일"
        label.textColor = DSKitAsset.Colors.gray30.color
        return label
    }()
    
    // MARK: - Initialization
    
    override func prepareForReuse() {
        super.prepareForReuse()
        attendanceStateDateLabel.text = nil
//        attendanceStateButton.titleLabel?.text = nil
//        attendanceStateButton.imageView?.image = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension MyAttendanceStateTVC {
    
    private func setLayout() {
        addSubviews(attendanceStateButton, attendanceStateDateLabel)
        
        attendanceStateButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
        
        attendanceStateDateLabel.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension MyAttendanceStateTVC {
    
}
