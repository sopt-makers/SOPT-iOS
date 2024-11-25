//
//  SoptlogHeaderView.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class SoptlogHeaderView: UICollectionReusableView {
 
    // MARK: - UI Components
    
    private let profileImageView = CustomProfileImageView()
    
    private let nameLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.bold.font(size: 20)
        $0.textColor = DSKitAsset.Colors.white.color
        $0.text = "차은우"
    }
    
    private let partLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.medium.font(size: 12)
        $0.textColor = DSKitAsset.Colors.gray100.color
        $0.text = "디자인/기획"
    }
    
    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 2
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        setStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SoptlogHeaderView {
    private func setUI() {
        self.backgroundColor = .clear
    }
    
    private func setLayout() {
        self.addSubviews(profileImageView, labelStackView)
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.leading.bottom.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
    }
    
    private func setStackView() {
        labelStackView.addArrangedSubviews(nameLabel, partLabel)
    }
}
