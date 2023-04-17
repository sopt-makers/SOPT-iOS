//
//  MyPageSectionListItemView.swift
//  AppMyPageFeature
//
//  Created by Ian on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core

import DSKit

public class MyPageSectionListItemView: UIView {
    private enum Metric {
        static let itemHeight = 32.f
        static let rightButtonSize = 32.f
                
        static let baseViewLeading = 16.f
        static let baseViewTrailing = 8.f
        static let baseViewTopBottom = 5.f
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.backgroundColor = DSKitAsset.Colors.black80.color
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.white100.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 16)
    }
    
    private let rightChevronButton = UIImageView().then {
        $0.image = DSKitAsset.Assets.btnArrowRight.image
    }
    
    init(title: String, frame: CGRect) {
        self.titleLabel.text = title
        
        super.init(frame: frame)
        
        self.backgroundColor = DSKitAsset.Colors.black80.color

        self.setupLayouts()
        self.setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPageSectionListItemView {
    private func setupLayouts() {
        self.addSubview(self.contentStackView)
        self.contentStackView.addArrangedSubviews(
            self.titleLabel,
            self.rightChevronButton
        )
    }
    
    private func setupConstraint() {
        self.contentStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Metric.baseViewLeading)
            $0.trailing.equalToSuperview().inset(Metric.baseViewTrailing)
            $0.top.bottom.equalToSuperview().inset(Metric.baseViewTopBottom)
            $0.height.equalTo(Metric.itemHeight)
        }
        
        self.rightChevronButton.snp.makeConstraints {
            $0.size.equalTo(Metric.rightButtonSize)
        }
    }
}
