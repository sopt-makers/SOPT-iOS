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
import MDS

final class CalendarCardCVC: UICollectionViewCell {
    
    // MARK: - Properties

    private(set) lazy var attendanceButtonTap = attendanceButton.publisher(for: .touchUpInside)
    private(set) var cancelBag = CancelBag()
    
    // MARK: - UI Components

    private let dateLabel = UILabel().then {
        $0.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.subtle)
    }
    
    private let scheduleCategoryTagView = MDSTag(text: "", size: .small, shape: .rect, variant: .secondary, style: .subtle)
    
    private let scheduleTitleLabel = UILabel().then {
        $0.setTypography(Typography.title4, textColor: SemanticColor.Fg.Neutral.bold)
    }
        
    private let rightArrowImageView = UIImageView().then {
        $0.image = MDSIcon.chevronRightOutlined.image.withRenderingMode(.alwaysTemplate)
        $0.tintColor = SemanticColor.Fg.Neutral.bold
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
    }
    
    private let attendanceButton = MDSActionButton(
        variant: .primary,
        size: .small,
        title: I18N.Home.DashBoard.Attendance.attendance,
        prefixIcon: .checkCircleFilled
    )
    
    private let scheduleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cancelBag.cancel()
        self.cancelBag = CancelBag()
    }
}

// MARK: - UI & Layout

extension CalendarCardCVC {
    private func setUI() {
        self.backgroundColor = SemanticColor.Bg.Neutral.ghost
        self.layer.cornerRadius = BaseRadius.Base.r8
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
        
        rightArrowImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        
        attendanceButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
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
    func configureCell(model: HomePresentationModel.RecentSchedule,
                       userType: UserType) {
        self.dateLabel.text = model.date
        self.dateLabel.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.subtle)
        self.scheduleTitleLabel.text = model.title
        self.scheduleTitleLabel.setTypography(Typography.title4, textColor: SemanticColor.Fg.Neutral.bold)
        if let tagType = CalenderCategoryTagType(rawValue: model.type) {
            self.scheduleCategoryTagView.text = tagType.text
            self.scheduleCategoryTagView.variant = tagType.tagType
        }
        self.attendanceButton.isHidden = (userType == .visitor || userType == .inactive)
    }
    
    func resetSubscription() {
        self.cancelBag.cancel()
        self.cancelBag = CancelBag()
    }
}
