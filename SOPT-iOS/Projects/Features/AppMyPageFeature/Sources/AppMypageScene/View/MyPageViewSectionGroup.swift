//
//  MyPageViewSectionGroup.swift
//  AppMyPageFeatureDemo
//
//  Created by Ian on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import DSKit
import Core

import SnapKit
import Then

public final class MypageSectionGroupView: UIView {
    private enum Metric {
        static let headerLabelLeading = 16.f
        static let headerLabelTop = 16.f
        static let headerLabelBottom = 12.f
        static let headerViewHeight = 43.f
        
        static let bottomInsetViewHeight = 16.f
        
        static let sectionGroupCornerRadius = 10.f
    }
    
    private let headerView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.black80.color
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.cornerRadius = Metric.sectionGroupCornerRadius
    }
    private let headerLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.gray80.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 12)
    }

    private let myPageSectionListItemView: [MyPageSectionListItemView]
    private lazy var stackView = UIStackView(frame: self.frame).then {
        $0.axis = .vertical
        $0.distribution = .fill
    }
    
    private let bottomInsetView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.black80.color
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        $0.layer.cornerRadius = Metric.sectionGroupCornerRadius
    }
    
    public init(
        headerTitle: String,
        subviews: [MyPageSectionListItemView],
        frame: CGRect
    ) {
        self.headerLabel.text = headerTitle
        self.myPageSectionListItemView = subviews
        
        super.init(frame: frame)
        
        self.setupLayouts()
        self.setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MypageSectionGroupView {
    private func setupLayouts() {
        self.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.headerView)
        self.myPageSectionListItemView.forEach { self.stackView.addArrangedSubview($0) }
        self.stackView.addArrangedSubview(self.bottomInsetView)
        
        self.headerView.addSubview(self.headerLabel)
    }
    
    private func setupConstraint() {
        self.stackView.snp.makeConstraints { $0.directionalEdges.equalToSuperview() }
        self.headerView.snp.makeConstraints {
            $0.height.equalTo(Metric.headerViewHeight)
        }
        self.headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Metric.headerLabelTop)
            $0.leading.equalToSuperview().inset(Metric.headerLabelLeading)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(Metric.headerLabelBottom)
        }
        self.bottomInsetView.snp.makeConstraints {
            $0.height.equalTo(Metric.bottomInsetViewHeight)
        }
    }
}
