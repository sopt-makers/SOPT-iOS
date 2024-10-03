//
//  DailySoptuneResultContentView.swift
//  DailySoptuneFeature
//
//  Created by Jae Hyun Lee on 9/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import DSKit
import Core
import Domain

public final class DailySoptuneResultContentView: UIView {
    
    // MARK: - UI Components
    
    private let soptuneLogoImage = UIImageView().then {
        $0.image = DSKitAsset.Assets.imgDailysoptune.image
    }
    
    private let dateLabel = UILabel().then {
        $0.font = UIFont.MDS.title5.font
        $0.textColor = DSKitAsset.Colors.gray100.color
    }
    
    private lazy var contentLabel = UILabel().then {
        $0.font = UIFont.MDS.title3.font
        $0.textColor = DSKitAsset.Colors.gray30.color
        $0.numberOfLines = 0
    }
    
    // MARK: - initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
        self.setLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension DailySoptuneResultContentView {
    private enum Metric {
        static let soptuneLogoWidth = 133.48.adjusted
        static let soptuneLogoRatio = 102.71 / 133.48
    }
    
    private func setUI() {
        self.backgroundColor = DSKitAsset.Colors.gray900.color
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        setContentLabel()
    }
    
    private func setContentLabel() {
        self.contentLabel.setLineSpacing(lineSpacing: 8)
        self.contentLabel.textAlignment = .center
    }
    
    private func setLayout() {
        self.addSubviews(soptuneLogoImage, dateLabel, contentLabel)
        
        soptuneLogoImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32.adjustedH)
            make.width.equalTo(Metric.soptuneLogoWidth)
            make.height.equalTo(Metric.soptuneLogoWidth * Metric.soptuneLogoRatio)
            make.centerX.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(soptuneLogoImage.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.bottom.equalTo(contentLabel.snp.bottom).offset(34)
        }
    }
}

extension DailySoptuneResultContentView {
    public func setData(model: DailySoptuneResultModel) {
        self.dateLabel.text = setDateFormat(to: "MM월 d일 EEEE")
        let adjustedText: String = model.title.setLineBreakAtMiddle()
        self.contentLabel.text = "\(model.userName)님,\n\(adjustedText)"
        self.contentLabel.setLineSpacing(lineSpacing: 5)
        self.contentLabel.textAlignment = .center
    }
}
