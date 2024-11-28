//
//  AppServiceSectionBackgroundView.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit

final class AppServiceSectionBackgroundView: UICollectionReusableView {
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension AppServiceSectionBackgroundView {
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.gray700.color
        self.layer.cornerRadius = 12
    }
}
