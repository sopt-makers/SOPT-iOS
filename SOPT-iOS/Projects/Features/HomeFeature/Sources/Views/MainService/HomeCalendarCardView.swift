//
//  HomeCalendarCardView.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

@frozen
enum HomeCalenderCardTag {
    case event
    case seminar
    var tag: HomeSquareTagView {
        switch self {
        case .event:
            return HomeSquareTagView()
                .setTitle(with: I18N.Home.MainService.Attendance.event)
                .setTitleColor(with: DSKitAsset.Colors.success.color)
                .setBackgroundColor(with: DSKitAsset.Colors.success.color.withAlphaComponent(0.2))
        case .seminar:
            return HomeSquareTagView()
                .setTitle(with: I18N.Home.MainService.Attendance.seminar)
                .setTitleColor(with: DSKitAsset.Colors.success.color)
                .setBackgroundColor(with: DSKitAsset.Colors.secondary.color.withAlphaComponent(0.2))
        }
    }
}

final class HomeCalendarCardView: UIView {
    
    // MARK: - Properties
    
    private var userType: UserType?
    
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
            var attributedTitle = AttributedString("출석")
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

extension HomeCalendarCardView {
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
            titleStackView
        )
    }
}

// MARK: - Methods

extension HomeCalendarCardView {
    func setData(date: String, tag: HomeCalenderCardTag, title: String, userType: UserType) {
        self.dateLabel.text = date
        self.scheduleTagView = tag.tag
        self.scheduleTitleLabel.text = title
        self.userType = userType
        self.scheduleTagView = tag.tag
        self.scheduleStackView.insertArrangedSubview(self.scheduleTagView, at: 1)
    }
}
