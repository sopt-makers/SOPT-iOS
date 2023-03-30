//
//  MissionListEmptyView.swift
//  Presentation
//
//  Created by Junho Lee on 2023/01/11.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

import SnapKit

class MissionListEmptyView: UIView {
    
    // MARK: - UI Component
    
    private let emptyImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = DSKitAsset.Assets.missilnListEmpty.image
        return iv
    }()
    
    private let noMissionLabel: UILabel = {
        let label = UILabel()
        label.text = I18N.MissionList.noMission
        label.setTypoStyle(.SoptampFont.subtitle2)
        label.textColor = DSKitAsset.Colors.soptampGray500.color
        return label
    }()
    
    // MARK: - Initialize
    
    public init() {
        super.init(frame: .zero)
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension MissionListEmptyView {
    private func setLayout() {
        self.addSubviews(emptyImage, noMissionLabel)
        
        emptyImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(212.adjusted)
            make.height.equalTo(196.adjusted)
        }
        
        noMissionLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImage.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
        }
    }
}
