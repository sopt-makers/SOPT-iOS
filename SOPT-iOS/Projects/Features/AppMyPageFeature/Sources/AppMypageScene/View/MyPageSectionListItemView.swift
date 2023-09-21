//
//  MyPageSectionListItemView.swift
//  AppMyPageFeature
//
//  Created by Ian on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core

import DSKit

public final class MyPageSectionListItemView: UIView {
    public enum RightItemType: Equatable {
        case chevron
        case `switch`(isOn: Bool)
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.chevron, .chevron): return true
            case (.switch(let leftParam), .switch(let rightParam)): return leftParam == rightParam
            default: return false
            }
        }
    }

    private enum Metric {
        static let itemHeight = 32.f
        static let rightButtonSize = 32.f
        
        static let rightItemSpacing = 0.f
                
        static let baseViewLeading = 16.f
        static let baseViewTrailing = 8.f
        static let switchViewTrailing = 18.f
        static let baseViewTopBottom = 5.f
    }
    
    private lazy var contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.backgroundColor = DSKitAsset.Colors.black80.color
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.white100.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 16)
    }
    
    private let rightItemStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = Metric.rightItemSpacing
        $0.distribution = .fill
    }
    
    private lazy var rightSwitch = AppSwitchView(isEnabled: false, frame: self.frame).then {
        $0.isHidden = true
    }
    
    private lazy var rightChevronView = UIImageView().then {
        $0.image = DSKitAsset.Assets.btnArrowRight.image
        $0.isHidden = true
    }
    
    private let rightItemType: RightItemType
    
    init(
        title: String,
        rightItemType: RightItemType = .chevron,
        frame: CGRect
    ) {
        self.titleLabel.text = title
        self.rightItemType = rightItemType

        super.init(frame: frame)
        
        switch rightItemType {
        case .chevron:
            self.rightChevronView.isHidden = false
        case .switch(let isOn):
            self.rightSwitch.isOn = isOn
            self.rightSwitch.isHidden = false
        }
        
        self.backgroundColor = DSKitAsset.Colors.black80.color

        self.setupLayouts()
        self.setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Public functions
extension MyPageSectionListItemView {
    public func signalForRightSwitchClick() -> AnyPublisher<Bool, Never> {
        return self.rightSwitch
            .publisher(for: .touchUpInside)
            .map(\.isOn)
            .eraseToAnyPublisher()
    }
    
    public func configureSwitch(to isOn: Bool) {
        self.rightSwitch.isOn = isOn
    }
}

// MARK: - Private functions
extension MyPageSectionListItemView {
    private func setupLayouts() {
        self.addSubview(self.contentStackView)
        self.contentStackView.addArrangedSubviews(
            self.titleLabel,
            self.rightItemStackView
        )
        self.rightItemStackView.addArrangedSubviews(
            self.rightChevronView,
            self.rightSwitch
        )
    }
    
    private func setupConstraint() {
        self.contentStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Metric.baseViewLeading)
            $0.trailing.equalToSuperview().inset(
                self.rightItemType == .chevron
                ? Metric.baseViewTrailing : Metric.switchViewTrailing
            )
            $0.top.bottom.equalToSuperview().inset(Metric.baseViewTopBottom)
            $0.height.equalTo(Metric.itemHeight)
        }
        
        self.rightChevronView.snp.makeConstraints {
            $0.size.equalTo(Metric.rightButtonSize)
        }
    }
}
