//
//  DashBoardProfileImageView.swift
//  HomeFeature
//
//  Created by 최주리 on 12/10/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit

final class DashBoardProfileImageView: UIView {
    let profileImageView = CustomProfileImageView().then {
        $0.hideBorder()
    }
    
    private let editBackgroundView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray600.color
        $0.layer.borderColor = DSKitAsset.Colors.gray800.color.cgColor
        $0.layer.borderWidth = 2.5
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    private let editImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icPencil.image
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DashBoardProfileImageView {
    private func setLayout() {
        self.addSubviews(profileImageView, editBackgroundView)
        editBackgroundView.addSubview(editImageView)
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(54)
        }
        
        editBackgroundView.snp.makeConstraints {
            $0.size.equalTo(17)
            $0.bottom.equalTo(profileImageView.snp.bottom).offset(-2.5)
            $0.trailing.equalTo(profileImageView.snp.trailing).offset(2)
        }
        
        editImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(8)
        }
    }
}

extension DashBoardProfileImageView {
    func configure(profileImageURL: String?) {
        guard let profileImageURL else { return }
        profileImageView.setImage(with: profileImageURL)
    }
}
