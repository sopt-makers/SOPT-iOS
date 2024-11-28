//
//  SoptlogAppServiceCVC.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class SoptlogAppServiceCVC: UICollectionViewCell {
    
    // MARK: - UI Components

    private let titleLabel = UILabel().then {
        $0.text = "솝레벨"
        $0.textColor = DSKitAsset.Colors.gray200.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 14)
    }
    
    private let serviceImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icHot.image
    }
    
    private let serviceLabel = UILabel().then {
        $0.text = "Lv.6"
        $0.textColor = DSKitAsset.Colors.white.color
        $0.font = DSKitFontFamily.Suit.bold.font(size: 16)
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

extension SoptlogAppServiceCVC {
    private func setUI() {
        contentView.backgroundColor = .clear
    }
    
    private func setLayout() {
        contentView.addSubviews(titleLabel, serviceImageView, serviceLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.top.equalToSuperview().inset(10)
        }
        
        serviceImageView.snp.makeConstraints { make in
            make.size.equalTo(39)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
        }
        
        serviceLabel.snp.makeConstraints { make in
            make.top.equalTo(serviceImageView.snp.bottom).offset(4)
            make.centerX.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension SoptlogAppServiceCVC {
    func configureCell(title: String, image: UIImage) {
        self.titleLabel.text = title
        self.serviceImageView.image = image
    }
}
