//
//  AppMyPageNavigationBar.swift
//  AppMyPageFeature
//
//  Created by Ian on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit

import Then
import SnapKit

final class AppMyPageNavigationBar: UIView {
    private enum Metric {
        static let leftChevronSize = 44.f
        static let navigationBarMinHeight = 44.f
        static let navigationBarLeadingTrailingCompansateFactor = 16.f
    }
    
    private let contentView = UIView()
    
    private(set) var leftChevronButton = UIButton(type: .custom).then {
        $0.setImage(DSKitAsset.Assets.btnArrowLeft.image, for: .normal)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.medium.font(size: 16)
        $0.textColor = DSKitAsset.Colors.white100.color
        $0.text = "마이페이지"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupLayouts()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppMyPageNavigationBar {
    private func setupLayouts() {
        self.addSubview(self.contentView)
        self.contentView.addSubviews(self.leftChevronButton, self.titleLabel)
    }
    
    private func setupConstraints() {
        self.contentView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
            $0.leading.trailing.equalToSuperview().inset(-Metric.navigationBarLeadingTrailingCompansateFactor)
            $0.width.equalTo(self.frame.size.width)
            $0.height.greaterThanOrEqualTo(Metric.navigationBarMinHeight)
        }
        
        self.leftChevronButton.snp.makeConstraints {
            $0.size.equalTo(Metric.leftChevronSize)
            $0.centerY.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
