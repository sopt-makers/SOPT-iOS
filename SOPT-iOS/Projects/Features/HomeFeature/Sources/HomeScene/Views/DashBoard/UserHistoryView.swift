//
//  UserHistoryView.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class UserHistoryView: UIView {
    
    // MARK: - Properties
    
    private let numberOfHistoryToShow: Int = 5
    
    // MARK: - UI Components
    
    private let userTypeLabel = UILabel().then {
        $0.backgroundColor = DSKitAsset.Colors.black40.color
        $0.textColor = DSKitAsset.Colors.white.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 12)
        $0.text = I18N.Home.DashBoard.UserHistory.encourage
        $0.layer.cornerRadius = 12
        $0.textAlignment = .center
        $0.clipsToBounds = true
    }
    
    private var historyStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.distribution = .fillEqually
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

extension UserHistoryView {
    private func setUI() {
        self.backgroundColor = .clear
    }
    
    private func setLayout() {
        self.addSubviews(
            userTypeLabel,
            historyStackView
        )
        
        userTypeLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(82)
        }
        
        historyStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(userTypeLabel.snp.trailing).offset(8)
        }
    }
}

// MARK: - Methods

extension UserHistoryView {
    func setData(recentHistory: Int?, allHistory: [Int]?) {
        // 현재 활동 기수 여부 뷰 설정
        let userType = UserDefaultKeyList.Auth.getUserType()
        let userTypeText = userType.makeDescription(recentHistory: recentHistory ?? 0)
        setUserTypeLabel(with: userType, text: userTypeText)
        guard userType != .visitor else { return }
        resetHistoryView()
        makeHistoryView(allHistory: allHistory)
    }
    
    private func setUserTypeLabel(with userType: UserType, text: String) {
        self.userTypeLabel.text = text
        self.userTypeLabel.textColor = userType == .active ? DSKitAsset.Colors.black100.color : DSKitAsset.Colors.white.color
        self.userTypeLabel.backgroundColor = userType == .active ? DSKitAsset.Colors.orange100.color : DSKitAsset.Colors.black40.color
    }
    
    private func resetHistoryView() {
        historyStackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
    }
    
    private func makeHistoryView(allHistory: [Int]?) {
        // 활동 기수들의 내역을 나열합니다.
        guard var allHistory = allHistory, !allHistory.isEmpty else { return }
        allHistory.removeFirst()
        
        for (index, history) in allHistory.enumerated() {
            if self.historyStackView.arrangedSubviews.count >= numberOfHistoryToShow { break }
            let historyItemView = UserHistoryItemView().setData(index: index, history: String(history))
            
            self.historyStackView.addArrangedSubview(historyItemView)
        }
        
        // 5개 이상의 기수를 활동한 경우 +n 으로 나타냅니다.
        let remaining = allHistory.count - numberOfHistoryToShow
        if remaining > 0 {
            let remainingItemView = UserHistoryItemView()
                .setData(index: 0, history: "+\(remaining)")
                .setBackgroundColor(with: DSKitAsset.Colors.gray800.color)
            self.historyStackView.addArrangedSubview(remainingItemView)
        }
    }
}
