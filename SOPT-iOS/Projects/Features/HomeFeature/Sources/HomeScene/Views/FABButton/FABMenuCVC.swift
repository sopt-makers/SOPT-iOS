//
//  FABMenuCVC.swift
//  HomeFeature
//
//  Created by 성현주 on 11/30/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//


import UIKit

import DSKit

final class FABMenuCVC: UICollectionViewCell {
    
    // MARK: - UI Componets
    
    private let menuImage = UIImageView()
    private let menuTitle = UILabel().then {
        $0.font = DSKitFontFamily.Suit.medium.font(size: 14)
        $0.textColor = DSKitAsset.Colors.gray950.color
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension FABMenuCVC {
    private func setLayout() {
        contentView.addSubviews(menuImage, menuTitle)
        
        menuImage.snp.makeConstraints { make in
            make.size.equalTo(22)
            make.top.equalToSuperview().inset(10)
            make.leading.bottom.equalToSuperview()
        }
        
        menuTitle.snp.makeConstraints { make in
            make.leading.equalTo(menuImage.snp.trailing).offset(6)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension FABMenuCVC {
    func configureCell(model: MenuSectionItem) {
        menuTitle.text = model.title
        menuImage.image = model.icon
    }
}
