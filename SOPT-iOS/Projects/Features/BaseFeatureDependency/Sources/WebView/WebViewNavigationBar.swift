//
//  WebViewNavigationBar.swift
//  BaseFeatureDependency
//
//  Created by Ian on 11/30/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import DSKit

import UIKit

internal final class WebViewNavigationBar: UIView {
    private enum Metric {
        static let navigationBarHeight = 44.f
        static let buttonLength = 44.f
        static let contentStackViewSpacing = 0.f
        static let contentStackViewLeadingTrailing = 8.f
        static let securityImageViewLength = 16.f
    }
    
    // MARK: LeftButton
    private let leftButton = UIButton().then {
        let image: UIImage = DSKitAsset.Assets.icClose.image.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = .white
    }
    
    private let contentSpacingView = UIView().then {
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    // MARK: RightButton
    private let rightButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        $0.tintColor = .white
    }
    
    private lazy var contentStackView = UIStackView(
        arrangedSubviews: [
            self.leftButton,
            self.contentSpacingView,
            self.rightButton
        ]
    ).then {
        $0.axis = .horizontal
        $0.spacing = Metric.contentStackViewSpacing
        $0.distribution = .equalCentering
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initializeViews()
        self.setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - Private functions
extension WebViewNavigationBar {
    private func initializeViews() {
        self.addSubview(self.contentStackView)
    }
    
    private func setupConstraints() {
        self.contentStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Metric.securityImageViewLength)
            $0.top.bottom.equalToSuperview()
            $0.height.equalTo(Metric.navigationBarHeight)
        }
        self.leftButton.snp.makeConstraints { $0.width.height.equalTo(Metric.buttonLength) }
        self.rightButton.snp.makeConstraints { $0.width.height.equalTo(Metric.buttonLength) }
    }
}

// MARK: - Public functions
extension WebViewNavigationBar {
    public func signalForClickLeftButton() -> Driver<Void> {
        self.leftButton.publisher(for: .touchUpInside).mapVoid().asDriver()
    }
    
    public func signalForClickRightButton() -> Driver<Void> {
        self.rightButton.publisher(for: .touchUpInside).mapVoid().asDriver()
    }
}
