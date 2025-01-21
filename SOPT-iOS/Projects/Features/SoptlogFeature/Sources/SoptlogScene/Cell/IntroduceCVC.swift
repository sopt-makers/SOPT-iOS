//
//  IntroduceCVC.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class IntroduceCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let introduceLabel = UILabel().then {
        $0.text = I18N.Soptlog.enrollIntroduce
        $0.font = DSKitFontFamily.Suit.medium.font(size: 14)
        $0.textColor = DSKitAsset.Colors.gray100.color
    }
    
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

// MARK: - UI & Layout

extension IntroduceCVC {
    private func setUI() {
        contentView.backgroundColor = DSKitAsset.Colors.gray800.color
        contentView.layer.cornerRadius = 8
    }
    
    private func setLayout() {
        contentView.addSubviews(introduceLabel)
        
        introduceLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension IntroduceCVC {
    func configureCell(model: SoptlogPresentationModel.Introduce?) {
        guard let model else { return }
        introduceLabel.text = model.profileMessage.count == 0 ? I18N.Soptlog.enrollIntroduce : model.profileMessage
    }
}
