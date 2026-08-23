//
//  HomeCalendarDetailCVC.swift
//  HomeFeatureDemo
//
//  Created by 강윤서 on 12/12/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Then
import MDS

final class HomeCalendarDetailCVC: UICollectionViewCell {
    
    // MARK: UI Components
    
    private let circleView = UIView().then {
//        $0.backgroundColor = SemanticColor.Fg.Neutral.ghost
        $0.layer.cornerRadius = 7.5
    }
    
    private let stickView = UIView().then {
        $0.backgroundColor = SemanticColor.Stroke.Neutral.default
    }
    
    private let dateLabel = UILabel().then {
        $0.setTypography(Typography.label4)
        $0.textColor = SemanticColor.Fg.Neutral.subtle
    }

    private let homeSquareTagView = MDSTag(text: "", size: .small, shape: .rect, variant: .secondary, style: .subtle)
    
    private let calendarTitleLabel = UILabel().then {
        $0.setTypography(Typography.title4)
        $0.textColor = SemanticColor.Fg.Neutral.bold
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI & Layout

extension HomeCalendarDetailCVC {
    private func setUI() {
        contentView.backgroundColor = .clear
    }
    
    private func setLayout() {
        contentView.addSubviews(circleView, stickView, dateLabel, homeSquareTagView, calendarTitleLabel)
        
        circleView.snp.makeConstraints { make in
            make.width.height.equalTo(13)
            make.top.equalToSuperview().inset(15)
            make.leading.equalToSuperview().inset(1.5)
        }
        
        stickView.snp.makeConstraints { make in
            make.top.equalTo(circleView.snp.bottom)
            make.centerX.equalTo(circleView)
            make.width.equalTo(1)
            make.bottom.equalToSuperview().offset(90)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(circleView.snp.trailing).offset(9.5)
            make.centerY.equalTo(circleView)
        }
        
        homeSquareTagView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(17)
            make.leading.equalTo(dateLabel)
        }
        
        calendarTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(homeSquareTagView)
            make.leading.equalTo(homeSquareTagView.snp.trailing).offset(10)
        }
    }
}

extension HomeCalendarDetailCVC {
    func configureCell(_ model: HomeCalendarDetailPresentationModel?) {
        guard let model else { return }
        dateLabel.text = model.date
        calendarTitleLabel.text = model.title
        if let tagType = CalenderCategoryTagType(rawValue: model.type) {
            self.homeSquareTagView.text = tagType.text
            // TODO: - MDS 수정 후 적용
//            self.homeSquareTagView.variant = tagType.tagType
        }
        circleView.backgroundColor = model.isRecentSchedule ? SemanticColor.Fg.Neutral.bold : SemanticColor.Fg.Neutral.ghost
    }
}
