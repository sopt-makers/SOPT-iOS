//
//  MainServiceHeaderView.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class MainServiceHeaderView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let contentView = UIView()
    
    private let userInfoLabel = UILabel().then {
        $0.text = I18N.Home.MainService.UserHistory.welcome
        $0.textColor = DSKitAsset.Colors.white100.color
        $0.font = DSKitFontFamily.Suit.bold.font(size: 18)
        $0.numberOfLines = 2
        $0.textAlignment = .left
        $0.setLineSpacing(lineSpacing: 5)
    }
    
    private let userHistoryView = UserHistoryView()
    
    private let rightArrowWithCircleImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.btnRightArrowWithCircle.image
    }
    
    // MARK: - initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension MainServiceHeaderView {
    private func setUI() {
        contentView.backgroundColor = DSKitAsset.Colors.gray800.color
        contentView.layer.cornerRadius = 8
    }
    
    private func setLayout() {
        self.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(123)
        }
        
        contentView.addSubviews(
            userInfoLabel,
            userHistoryView
        )
        
        userInfoLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
        
        userHistoryView.snp.makeConstraints { make in
            make.top.equalTo(userInfoLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(250)
            make.height.equalTo(23)
        }
    }
    
    private func setRightArrowWithCircleImageViewLayout() {
        contentView.addSubview(rightArrowWithCircleImageView)
        
        rightArrowWithCircleImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(32)
        }
    }
}

// MARK: - Methods

extension MainServiceHeaderView {
    func initCell(userType: UserType) {
        switch userType {
        case .visitor:
            self.userInfoLabel.text = I18N.Home.MainService.UserHistory.encourage
        case .active, .inactive:
            self.userInfoLabel.text = I18N.Home.MainService.UserHistory.welcome
            setRightArrowWithCircleImageViewLayout()
        }
        
        userHistoryView.setData(userType: userType, recentHistory: 3, allHistory: [35, 34, 33])
    }
}
