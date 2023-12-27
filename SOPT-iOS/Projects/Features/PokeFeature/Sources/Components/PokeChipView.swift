//
//  PokeChipView.swift
//  PokeFeature
//
//  Created by Ian on 12/3/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final public class PokeChipView: UIView {
    
    // MARK: Private Constants
    private enum Constant {
        static let dotWithWhiteSpace = " · "
    }
    
    private enum Metrics {
        static let chipHeight = 20.f
        static let contentLeadingTrailing = 6.f
        static let contentTopBottom = 3.f
        
        static let titleLabelHeight = 14.f
    }
    
    // MARK: SubViews
    private let contentView = UIView().then {
        $0.layer.cornerRadius = 4.f
        $0.backgroundColor = DSKitAsset.Colors.semanticBackground.color
    }
    private lazy var contentStackView = UIStackView(frame: self.frame)
    private let titleLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 11)
        $0.textColor = DSKitAsset.Colors.gray100.color
        $0.textAlignment = .center
        $0.lineBreakMode = .byTruncatingTail
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.contentStackView)
        self.contentStackView.addArrangedSubview(self.titleLabel)

        self.contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.center.equalToSuperview()
        }
        self.contentStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Metrics.contentLeadingTrailing)
            $0.top.bottom.equalToSuperview().inset(Metrics.contentTopBottom)
            $0.center.equalToSuperview()
            $0.height.equalTo(Metrics.titleLabelHeight)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PokeChipView {
    public func configure(with text: String) {
        self.titleLabel.text = text
    }
}
