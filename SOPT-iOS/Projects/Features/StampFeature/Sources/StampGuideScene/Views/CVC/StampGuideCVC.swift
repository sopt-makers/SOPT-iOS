//
//  StampGuideCVC.swift
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

public class StampGuideCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .SoptampFont.h1
        $0.textColor = DSKitAsset.Colors.white.color
    }
    
    private let captionLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = DSKitAsset.Colors.gray200.color
        $0.text = " "
        $0.numberOfLines = 2
        $0.font = .SoptampFont.subtitle2
        $0.setLineSpacing(lineSpacing: 5)
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

extension StampGuideCVC {
    
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.gray950.color
    }
    
    private func setLayout() {
        addSubviews(imageView, titleLabel, captionLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(335)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension StampGuideCVC {
    
    func setStampGuideSlides(_ slides: StampGuideDataModel) {
        imageView.image = slides.image
        titleLabel.text = slides.title
        captionLabel.text = slides.caption
    }
}
