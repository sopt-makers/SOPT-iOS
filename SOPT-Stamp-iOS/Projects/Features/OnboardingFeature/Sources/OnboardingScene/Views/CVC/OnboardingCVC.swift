//
//  OnboardingCVC.swift
//  Presentation
//
//  Created by devxsby on 2022/12/01.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import DSKit

import Domain

import SnapKit
import Then

public class OnboardingCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.setTypoStyle(.SoptampFont.h1)
        $0.textColor = DSKitAsset.Colors.gray900.color
    }
    
    private let captionLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = DSKitAsset.Colors.gray500.color
        $0.text = " "
        $0.numberOfLines = 2
        $0.setTypoStyle(.SoptampFont.subtitle2)
        $0.setLineSpacing(lineSpacing: 8)
        $0.textAlignment = .center
    }
    
    // MARK: - Initialization
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

extension OnboardingCVC {
    
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.white.color
    }
    
    private func setLayout() {
        addSubviews(imageView, titleLabel, captionLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(contentView.snp.width).multipliedBy(0.8.adjustedH)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(45)
            make.centerX.equalToSuperview()
        }
        
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension OnboardingCVC {

    func setOnboardingSlides(_ slides: OnboardingDataModel) {
        imageView.image = slides.image
        titleLabel.text = slides.title
        captionLabel.text = slides.caption
    }
}
