//
//  CustomProfileImageView.swift
//  DSKit
//
//  Created by Jae Hyun Lee on 10/3/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Domain

/// 테두리가 있는 원형 프로필 이미지 뷰
public final class CustomProfileImageView: UIImageView {
    
    // MARK: - Properties
    
    public lazy var tap = self.gesture().mapVoid().asDriver()
    
    // MARK: - initialization
    
    public init() {
        super.init(frame: .zero)
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.gray700.color
        self.image = DSKitAsset.Assets.iconDefaultProfile.image
        self.clipsToBounds = true
        self.layer.borderWidth = 2
        self.contentMode = .scaleAspectFill
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2
    }
}
