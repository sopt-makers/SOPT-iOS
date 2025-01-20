//
//  EditProfileCVC.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class EditProfileCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let editProfileButton = AppOutlinedButton(title: I18N.Soptlog.editProfile)
        .chageTextColor(textColor: DSKitAsset.Colors.gray100.color)
        .chageOutlinedColor(outlinedColor: DSKitAsset.Colors.gray100.color)
    
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

extension EditProfileCVC {
    private func setUI() {
        contentView.backgroundColor = .clear
        editProfileButton.isEnabled = false
    }
    
    private func setLayout() {
        contentView.addSubviews(editProfileButton)
        
        editProfileButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
