//
//  IntroduceButtonCVC.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class IntroduceButtonCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let enrollIntroduceButton = AppCustomButton(title: I18N.Soptlog.enrollIntroduce)
        .changeCornerRadius(radius: 8)
        .setConfigForState(bgColor: DSKitAsset.Colors.gray700.color,
                           enabledTextColor: DSKitAsset.Colors.gray100.color,
                           enabledFont: DSKitFontFamily.Suit.semiBold.font(size: 12))
        
    
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension IntroduceButtonCVC {
    private func setUI() {
        contentView.backgroundColor = .clear
    }
    
    private func setLayout() {
        contentView.addSubviews(enrollIntroduceButton)
        
        enrollIntroduceButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
