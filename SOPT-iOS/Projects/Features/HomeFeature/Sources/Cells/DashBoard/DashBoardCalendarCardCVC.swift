//
//  DashBoardCalendarCardCVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

@frozen
enum MainServiceCalenderCardTag {
    case event
    case seminar
    
    var title: String {
        switch self {
        case .event:
            return I18N.Home.DashBoard.Attendance.event
        case .seminar:
            return I18N.Home.DashBoard.Attendance.seminar
        }
    }
    
    var titleColor: UIColor {
        return DSKitAsset.Colors.success.color
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .event:
            return DSKitAsset.Colors.success.color.withAlphaComponent(0.2)
        case .seminar:
            return DSKitAsset.Colors.secondary.color.withAlphaComponent(0.2)
        }
    }
}

final class DashBoardCalendarCardCVC: UICollectionViewCell {
    
    // MARK: - UI Components

    private let dateLabel = UILabel().then {
        $0.text = "10.22"
        $0.textColor = DSKitAsset.Colors.gray400.color
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
    }
    
    private let scheduleTitleLabel = UILabel().then {
        $0.text = "1차 행사"
        $0.textColor = DSKitAsset.Colors.white.color
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 16)
    }
    
    private var scheduleTagView = HomeSquareTagView()
    
    private let rightArrowImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.chevronRight.image.withTintColor(DSKitAsset.Colors.white.color)
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    private let attendanceButton = UIButton(type: .custom).then {
        $0.configuration = UIButton.Configuration.filled()
        $0.configurationUpdateHandler = { button in
            guard var configuration = button.configuration else { return }
            /// 타이틀 설정
            var attributedTitle = AttributedString(I18N.Home.DashBoard.Attendance.attendance)
            var attributes = AttributeContainer()
            attributes.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
            attributes.foregroundColor = DSKitAsset.Colors.black.color
            attributedTitle.setAttributes(attributes)
            configuration.attributedTitle = attributedTitle
            
            /// 이미지 설정
            configuration.image = DSKitAsset.Assets.icCheckCircleFilled.image
            configuration.imagePadding = 4
            
            /// 백그라운드 설정
            configuration.baseBackgroundColor = DSKitAsset.Colors.white.color
            configuration.background.cornerRadius = 5
            
            button.configuration = configuration
        }
    }
    
    private let scheduleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    // MARK: - initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setLayout()
        self.setStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension DashBoardCalendarCardCVC {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.gray800.color
        self.layer.cornerRadius = 8
    }
    
    private func setLayout() {
        self.addSubviews(
            scheduleStackView,
            attendanceButton
        )
        
        scheduleStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        attendanceButton.snp.makeConstraints { make in
            make.width.equalTo(73)
            make.top.bottom.trailing.equalToSuperview().inset(10)
        }
    }
    
    private func setStackView() {
        titleStackView.addArrangedSubviews(
            scheduleTitleLabel,
            rightArrowImageView
        )
        
        scheduleStackView.addArrangedSubviews(
            dateLabel,
            scheduleTagView,
            titleStackView
        )
    }
}

// MARK: - Methods

extension DashBoardCalendarCardCVC {
    func configureCell(date: String, tagType: MainServiceCalenderCardTag, title: String, userType: UserType) {
        self.dateLabel.text = date
        self.scheduleTitleLabel.text = title
        self.scheduleTagView.setData(title: tagType.title,
                                     titleColor: tagType.titleColor,
                                     backgroundColor: tagType.backgroundColor)
        self.attendanceButton.isHidden = userType == .visitor
    }
}
