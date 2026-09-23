//
//  PokeOnboardingNavigationBar.swift
//  PokeFeatureInterface
//
//  Created by Ian on 12/17/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import DSKit
import MDS

import UIKit

internal final class PokeOnboardingNavigationBar: UIView {
    private enum Metric {
        static let navigationBarHeight = 44.f
        static let buttonLength = 44.f
        static let contentStackViewSpacing = 10.f
        static let contentStackViewLeadingTrailing = 8.f
        static let securityImageViewLength = 16.f
    }
    
    // MARK: LeftButton
    private let leftButton = UIButton().then {
        $0.setImage(MDSIcon.xCloseOutlined.image.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = SemanticColor.Fg.Neutral.bold
    }
    
    private let leftTitleLabel = UILabel().then {
        $0.text = I18N.Poke.poke
        $0.setTypography(Typography.title4, textColor: SemanticColor.Fg.Neutral.bold)
    }
    
    private let contentSpacingView = UILabel().then {
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        $0.text = String(repeating: "   ", count: 1000)
    }
    
    private lazy var contentStackView = UIStackView(
        arrangedSubviews: [
            self.leftButton,
            self.leftTitleLabel,
            self.contentSpacingView
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
extension PokeOnboardingNavigationBar {
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
    }
}

// MARK: - Public functions
extension PokeOnboardingNavigationBar {
    public func signalForClickLeftButton() -> Driver<Void> {
        self.leftButton.publisher(for: .touchUpInside).mapVoid().asDriver()
    }
}
