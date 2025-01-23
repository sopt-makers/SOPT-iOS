//
//  DashBoardCalendarCardCVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Domain
import Core
import DSKit

final class CalendarCardCVC: UICollectionViewCell {
    
    // MARK: - UI Components

    private let dateLabel = UILabel().then {
        $0.text = "10.22"
        $0.textColor = DSKitAsset.Colors.gray400.color
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
    }
    
    private let scheduleCategoryTagView = HomeSquareTagView()
    
    private let scheduleTitleLabel = UILabel().then {
        $0.text = "1차 행사"
        $0.textColor = DSKitAsset.Colors.white.color
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 16)
    }
        
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

extension CalendarCardCVC {
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
            scheduleCategoryTagView,
            titleStackView
        )
    }
}

// MARK: - Methods

extension CalendarCardCVC {
    func configureCell(model: HomeRecentScheduleModel?,
                       userType: UserType) {
        guard let model = model else { return }
        self.dateLabel.text = model.date
        self.scheduleTitleLabel.text = model.title
        if let tagType = CalenderCategoryTagType(rawValue: model.type) {
            self.scheduleCategoryTagView.setData(title: tagType.text,
                                                 titleColor: tagType.textColor,
                                                 backgroundColor: tagType.backgroundColor)
        }
        self.attendanceButton.isHidden = userType == .visitor
    }
}
