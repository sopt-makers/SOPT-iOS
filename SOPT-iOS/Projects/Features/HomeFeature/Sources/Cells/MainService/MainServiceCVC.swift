//
//  MainServiceCVC.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class MainServiceCVC: UICollectionViewCell {

    // MARK: - UI Components

    private let homeCalendarCardView = HomeCalendarCardView()
    
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

// MARK: - UI & Layout

extension MainServiceCVC {
    private func setUI() {
        
    }
    
    private func setLayout() {
        self.addSubviews(homeCalendarCardView)
        
        homeCalendarCardView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
    }
}

// MARK: - Methods

extension MainServiceCVC {
    func initCell(userType: UserType) {
        homeCalendarCardView.setData(date: "10.22",
                                     tag: .event,
                                     title: "1차 행사",
                                     userType: userType)
    }
}
