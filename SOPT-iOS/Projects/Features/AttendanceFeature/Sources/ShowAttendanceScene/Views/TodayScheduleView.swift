//
//  TodayScheduleView.swift
//  AttendanceFeature
//
//  Created by devxsby on 2023/04/12.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit

/*
 출석 조회하기 뷰의 상단 오늘의 일정을 보여주는 뷰 입니다.
 */

final class TodayScheduleView: UIView {
    
    private enum Metric {
        static let todayAttendanceHeight = 51.f
    }
    
    // MARK: - Properties
    
    var scheduleType: AttendanceScheduleType = .scheduledDay {
        didSet {
            updateLayout(scheduleType)
        }
    }
    
    // MARK: - UI Components

    private let dateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .Main.body2
        label.textColor = DSKitAsset.Colors.gray300.color
        return label
    }()
    
    private let placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.textColor = DSKitAsset.Colors.gray300.color
        label.font = .Main.body2
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = DSKitAsset.Colors.gray10.color
        label.font = DSKitFontFamily.Suit.regular.font(size: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = DSKitAsset.Colors.gray100.color
        label.font = .Main.body2
        return label
    }()
    
    private lazy var dateStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [dateImageView, dateLabel])
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var placeStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [placeImageView, placeLabel])
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var dateAndPlaceStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [dateStackView, placeStackView])
        stackView.axis = .vertical
        stackView.spacing = 7
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var todayInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateAndPlaceStackView, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.setCustomSpacing(15, after: dateAndPlaceStackView)
        return stackView
    }()
    
    private let todayAttendanceView = TodayAttendanceView()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            todayInfoStackView,
            subtitleLabel,
            todayAttendanceView
        ])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .leading
        return stackView
    }()
    
    // MARK: - Initialization

    init(type: AttendanceScheduleType) {
        super.init(frame: .zero)
        
        initContentView()
        initLayout(type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension TodayScheduleView {
    
    private func initContentView() {
        self.backgroundColor = DSKitAsset.Colors.gray800.color
        self.clipsToBounds = true
        self.layer.cornerRadius = 16
    }
    
    private func initLayout(_ type: AttendanceScheduleType) {
        addSubview(containerStackView)
        
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(32)
        }
        
        todayAttendanceView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        if case .unscheduledDay = type {
            isHiddenScheduledLayout(true)
        }
    }
    
    private func updateLayout(_ type: AttendanceScheduleType) {
        if case .unscheduledDay = type {
            isHiddenScheduledLayout(true)
            addUnscheduledTitle()
        } else {
            isHiddenScheduledLayout(false)
        }
    }
    
    private func isHiddenScheduledLayout(_ bool: Bool) {
        dateAndPlaceStackView.isHidden = bool
        todayAttendanceView.isHidden = bool
        subtitleLabel.isHidden = bool
    }
}

// MARK: - Methods

extension TodayScheduleView {
    
    func setData(date: String, place: String, todaySchedule: String, description: String?) {
        
        setDefaultLayout()
        
        dateLabel.text = date
        placeLabel.text = place
        titleLabel.text = I18N.Attendance.today + todaySchedule + I18N.Attendance.dayIs
        titleLabel.partFontChange(targetString: todaySchedule,
                                  font: DSKitFontFamily.Suit.bold.font(size: 18))
        subtitleLabel.text = description
        subtitleLabel.isHidden = ((description?.isEmpty) == nil || description == "")
        
        checkNoAttendanceSession()
    }
    
    func setAttendanceInfo(_ attendances: [AttendanceStepModel], _ hasAttendance: Bool, attendanceType: TakenAttendanceType) {
        todayAttendanceView.setTodayAttendances(attendances, attendanceType: attendanceType)
        todayAttendanceView.isHidden = !hasAttendance
    }
    
    private func addUnscheduledTitle() {
        titleLabel.text = I18N.Attendance.today + I18N.Attendance.unscheduledDay + I18N.Attendance.dayIs
        titleLabel.setTypoStyle(DSKitFontFamily.Suit.medium.font(size: 16))
    }
        
    private func setDefaultLayout() {
        dateImageView.image = DSKitAsset.Assets.opDate.image
        placeImageView.image = DSKitAsset.Assets.opPlace.image
    }
    
    private func checkNoAttendanceSession() {
        if subtitleLabel.text == I18N.Attendance.noAttendanceSession {
            todayAttendanceView.isHidden = true
        }
    }
}
