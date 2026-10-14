//
//  UserHistoryView.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import MDS

final class UserHistoryView: UIView {
    
    // MARK: - Properties
    
    private let numberOfHistoryToShow: Int = 5
    
    // MARK: - UI Components

    private let userTypeTag = MDSTag(
        text: "",
        size: .small,
        shape: .pill,
        variant: .primary,
        style: .solid
    )
    
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
            userTypeTag,
            historyStackView
        )
        
        userTypeTag.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(82)
        }
        
        historyStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(userTypeTag.snp.trailing).offset(8)
        }
    }
}

// MARK: - Methods

extension UserHistoryView {
    func setData(recentHistory: Int?, allHistory: [Int]?) {
        // 현재 활동 기수 여부 뷰 설정
        let userType = UserDefaultKeyList.CoreAuth.getUserType()
        let userTypeText = userType.makeDescription(recentHistory: recentHistory ?? 0)
        setUserTypeLabel(with: userType, text: userTypeText)
        guard userType != .visitor else { return }
        resetHistoryView()
        makeHistoryView(allHistory: allHistory)
    }
    
    private func setUserTypeLabel(with userType: UserType, text: String) {
        self.userTypeTag.text = text
        // TODO: - 수료 tag 반영 후 수정
//        self.userTypeLabel.textColor = userType == .active ? DSKitAsset.Colors.black100.color : DSKitAsset.Colors.white.color
//        self.userTypeLabel.backgroundColor = userType == .active ? DSKitAsset.Colors.orange100.color : DSKitAsset.Colors.black40.color
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
                .setBackgroundColor(with: SemanticColor.Bg.Neutral.ghost)
            self.historyStackView.addArrangedSubview(remainingItemView)
        }
    }
}
