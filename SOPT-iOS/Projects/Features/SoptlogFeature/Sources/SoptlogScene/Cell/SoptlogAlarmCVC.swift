//
//  SoptlogAlarmCVC.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class SoptlogAlarmCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let serviceImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.imgDailysoptune.image
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textColor = DSKitAsset.Colors.white.color
        $0.font = DSKitFontFamily.Suit.bold.font(size: 18)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = I18N.Soptlog.dailyFortuneButton
        $0.textColor = DSKitAsset.Colors.gray200.color
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 12)
    }
    
    private let arrowImageview = UIImageView().then {
        $0.image = DSKitAsset.Assets.chevronRight.image
            .withTintColor(DSKitAsset.Colors.gray200.color)
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

extension SoptlogAlarmCVC {
    private func setUI() {
        contentView.backgroundColor = DSKitAsset.Colors.gray800.color
    }
    
    private func setLayout() {
        contentView.addSubviews(serviceImageView, titleLabel, subTitleLabel, arrowImageview)
        
        serviceImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(19)
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(serviceImageView.snp.trailing).offset(14)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        arrowImageview.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.top.equalTo(subTitleLabel.snp.top)
            make.leading.equalTo(subTitleLabel.snp.trailing)
        }
    }
}

// MARK: - Methods

extension SoptlogAlarmCVC {
    func configureCell(model: SoptlogPresentationModel.Alarm?) {
        guard let model else { return }
        self.titleLabel.text = model.todayFortuneText
    }
}
