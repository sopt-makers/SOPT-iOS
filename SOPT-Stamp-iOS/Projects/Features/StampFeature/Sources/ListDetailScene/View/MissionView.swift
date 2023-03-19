//
//  MissionView.swift
//  Presentation
//
//  Created by 양수빈 on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Combine
import SnapKit

import Core
import DSKit

class MissionView: UIView {
    // MARK: - UI Component
    
    private let starView = StarView(starScale: 14, spacing: 10, level: .levelOne)
    private let missionLabel = UILabel()
    
    // MARK: - Properties
    
    // MARK: - Initialize
    
    private override init(frame: CGRect) {
        super.init(frame: frame)

        self.setUI()
        self.setLayout()
    }
    
    public convenience init(level: StarViewLevel, mission: String) {
        self.init()
        self.missionLabel.text = mission
        starView.changeStarLevel(level: level)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.layer.cornerRadius = 9
        self.missionLabel.textColor = DSKitAsset.Colors.gray900.color
        self.missionLabel.setTypoStyle(.subtitle1)
    }
    
    private func setLayout() {
        self.addSubviews([starView, missionLabel])
        
        starView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(12)
            make.height.equalTo(14)
        }
        
        missionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(starView.snp.bottom).offset(8)
        }
    }
    
    // MARK: - Custom Method
    
}

