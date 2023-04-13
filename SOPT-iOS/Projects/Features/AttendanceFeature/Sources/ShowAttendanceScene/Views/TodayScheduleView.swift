//
//  TodayScheduleView.swift
//  AttendanceFeature
//
//  Created by devxsby on 2023/04/12.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

public enum TodayScheduleType {
    case unscheduledDay /// 일정 없는 날
    case scheduledDay /// 일정(세미나, 행사) 있는 날
}

/*
 출석 조회하기 뷰의 상단 오늘의 일정을 보여주는 뷰 입니다.
 */

final class TodayScheduleView: UIView {
    
    // MARK: - UI Components

    private let dateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = DSKitAsset.Assets.opDate.image
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .Main.body2
        label.textColor = DSKitAsset.Colors.gray60.color
        return label
    }()
    
    private let placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = DSKitAsset.Assets.opPlace.image
        return imageView
    }()
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.textColor = DSKitAsset.Colors.gray60.color
        label.font = .Main.body2
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = I18N.Attendance.today + I18N.Attendance.unscheduledDay + I18N.Attendance.dayIs
        label.font = .Main.headline2
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = DSKitAsset.Colors.gray30.color
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
        stackView.spacing = 16
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var containerStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [todayInfoStackView, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .leading
        return stackView
    }()

    // MARK: - Initialization

    init(type: TodayScheduleType) {
        super.init(frame: .zero)
        confiureContentView()
        setLayout(type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension TodayScheduleView {
    
    private func confiureContentView() {
        self.backgroundColor = DSKitAsset.Colors.black60.color
        self.clipsToBounds = true
        self.layer.cornerRadius = 16
    }
    
    private func setLayout(_ type: TodayScheduleType) {
        
        addSubview(containerStackView)
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        switch type {
        case .unscheduledDay:
            self.setUnscheduledDayLayout()
        case .scheduledDay:
            self.setSeminarDayLayout()
        }
    }
    
    private func setUnscheduledDayLayout() {
        
        dateAndPlaceStackView.isHidden = true
        
        addSubview(titleLabel)
                
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(32)
            $0.leading.equalToSuperview().offset(32)
        }
        
    }
    
    private func setSeminarDayLayout() {
        
        containerStackView.snp.updateConstraints {
            $0.edges.equalToSuperview().inset(32)
        }
    }
}

extension TodayScheduleView {
    
    func setData(date: String, place: String, todaySchedule: String, description: String?) {
        dateLabel.text = date
        placeLabel.text = place
        titleLabel.text = I18N.Attendance.today + " " + todaySchedule + " " + I18N.Attendance.dayIs
        titleLabel.partFontChange(targetString: todaySchedule,
                                  font: DSKitFontFamily.Suit.bold.font(size: 18))
        subtitleLabel.text = description
        subtitleLabel.isHidden = ((description?.isEmpty) == nil)
    }
}
