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

final class MissionView: UIView {
    
    // MARK: - UI Component
    
    private lazy var defaultStarView = STStarView(starScale: 14, spacing: 10, level: .levelOne)
    private lazy var levelTenStarView = STLevelTenStarView()
    
    private let missionLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    // MARK: - Properties
    
    // MARK: - Initialize
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
    }
    
    public convenience init(level: StarViewLevel, mission: String) {
        self.init()
        self.setMissionLabelText(mission)
        self.setLayout(level: level)
        defaultStarView.changeStarLevel(level: level)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.layer.cornerRadius = 9
        self.missionLabel.textColor = DSKitAsset.Colors.white.color
        self.missionLabel.setTypoStyle(.SoptampFont.subtitle1)
    }
    
    private func setLayout(level: StarViewLevel) {
        let starView = level == .levelTen ? levelTenStarView : defaultStarView
        
        self.addSubviews([starView, missionLabel])
        
        starView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(12)
        }
        
        missionLabel.snp.makeConstraints { make in
            make.top.equalTo(starView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        self.snp.makeConstraints { make in
            make.bottom.equalTo(missionLabel.snp.bottom).offset(11)
        }
    }
}

// MARK: - Methods

extension MissionView {
    private func setMissionLabelText(_ mission: String) {
        self.missionLabel.text = (mission.count >= 24) ? mission.setLineBreakAtMiddle() : mission
        self.missionLabel.modifyLineSpacing(lineSpacing: 2)
    }
}

