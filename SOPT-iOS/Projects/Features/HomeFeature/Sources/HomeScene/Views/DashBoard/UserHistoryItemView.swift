//
//  UserHistoryItemView.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import MDS

final class UserHistoryItemView: UIView {
    
    // MARK: - Properties
    
    private let historyViewColors: [UIColor] = [
        SemanticColor.Bg.Neutral.default,
        SemanticColor.Bg.Neutral.subtle,
        SemanticColor.Bg.Neutral.ghost,
        SemanticColor.Bg.Neutral.ghost,
        SemanticColor.Bg.Neutral.ghost
    ]
    
    private let historyViewTextColor: [UIColor] = [
        SemanticColor.Fg.Neutral.bold,
        SemanticColor.Fg.Neutral.bold,
        SemanticColor.Fg.Neutral.default,
        SemanticColor.Fg.Neutral.subtle,
        SemanticColor.Fg.Neutral.subtle
    ]
    
    // MARK: - UI Components
    
    private let historyLabel = UILabel().then {
        $0.setTypography(Typography.label4, alignment: .center)
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
        self.historyLabel.text = history
        let textColor = historyViewTextColor[safe: index]
        self.historyLabel.setTypography(Typography.label4, textColor: textColor, alignment: .center)
        
        self.backgroundColor = historyViewColors[safe: index]
        return self
    }
    
    @discardableResult
    func setBackgroundColor(with color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
}


