//
//  UserHistoryItemView.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class UserHistoryItemView: UIView {
    
    // MARK: - Properties
    
    private let historyViewColors: [UIColor] = [
        DSKitAsset.Colors.gray600.color,
        DSKitAsset.Colors.gray700.color,
        DSKitAsset.Colors.gray800.color,
        DSKitAsset.Colors.gray800.color,
        DSKitAsset.Colors.gray800.color
    ]
    
    private let historyViewTextColor: [UIColor] = [
        DSKitAsset.Colors.white.color,
        DSKitAsset.Colors.gray10.color,
        DSKitAsset.Colors.gray100.color,
        DSKitAsset.Colors.gray200.color,
        DSKitAsset.Colors.gray300.color
    ]
    
    // MARK: - UI Components
    
    private let historyLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.medium.font(size: 12)
        $0.textAlignment = .center
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius()
        setSize()
    }
}

// MARK: - UI & Layout

extension UserHistoryItemView {
    private func setLayout() {
        self.addSubview(historyLabel)
        
        historyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setCornerRadius() {
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    private func setSize() {
        self.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(self.snp.height)
        }
    }
}

// MARK: - Methods

extension UserHistoryItemView {
    @discardableResult
    func setData(index: Int, history: String) -> Self {
        self.historyLabel.textColor = historyViewTextColor[safe: index]
        self.historyLabel.text = history
        
        self.backgroundColor = historyViewColors[safe: index]
        return self
    }
    
    @discardableResult
    func setBackgroundColor(with color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
}


