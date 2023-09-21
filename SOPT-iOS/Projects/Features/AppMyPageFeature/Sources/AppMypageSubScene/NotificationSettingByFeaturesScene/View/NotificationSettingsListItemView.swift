//
//  NotificationSettingsListItemView.swift
//  AppMyPageFeatureInterface
//
//  Created by Ian on 2023/09/18.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core

import DSKit

public final class NotificationSettingsListItemView: UIView {
    private enum Metric {
        static let itemHeight = 40.f
                
        static let contentsViewLeadingTrailing = 20.f
    }
    
    private lazy var contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = DSKitAsset.Colors.white100.color
        $0.font = DSKitFontFamily.Suit.medium.font(size: 16)
    }
    
    private lazy var rightSwitch = AppSwitchView(isEnabled: false, frame: self.frame)
    
    init(
        title: String,
        frame: CGRect
    ) {
        super.init(frame: frame)
        
        self.titleLabel.text = title
        
        self.setupLayouts()
        self.setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public functions
extension NotificationSettingsListItemView {
    public func signalForRightSwitchClick() -> AnyPublisher<Bool, Never> {
        return self.rightSwitch
            .publisher(for: .touchUpInside)
            .map(\.isOn)
            .eraseToAnyPublisher()
    }
    
    public func configureRightSwitch(to isOn: Bool?) {
        self.rightSwitch.isOn = isOn ?? false
    }
}

// MARK: - Private functions
extension NotificationSettingsListItemView {
    private func setupLayouts() {
        self.addSubview(self.contentStackView)
        self.contentStackView.addArrangedSubviews(
            self.titleLabel,
            self.rightSwitch
        )
    }
    
    private func setupConstraint() {
        self.contentStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Metric.contentsViewLeadingTrailing)
            $0.top.bottom.equalToSuperview()
            $0.height.equalTo(Metric.itemHeight)
        }
    }
}
