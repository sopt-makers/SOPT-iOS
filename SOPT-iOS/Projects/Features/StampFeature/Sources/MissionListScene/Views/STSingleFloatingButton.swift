//
//  STFloatingButton.swift
//  StampFeature
//
//  Created by 최주리 on 12/17/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import MDS

final class STSingleFloatingButton: UIView {

    // MARK: - Properties

    public lazy var buttonTapped = floatingButton.gesture().mapVoid().asDriver()

    // MARK: - UI Components

    private let floatingButton = UIButton().then {
        $0.layer.cornerRadius = 54 / 2
        $0.backgroundColor = SemanticColor.Bg.Neutral.inverse
    }
    
    private let badgeView = MDSTag(
        text: "New",
        size: .small,
        shape: .pill,
        variant: .primary,
        style: .solid
    ).then {
        $0.isHidden = true
    }
    
    // MARK: - Initialization
    
    init(frame: CGRect, title: String, withImage: Bool = false, showBadge: Bool = false) {
        super.init(frame: frame)
        
        setLayout()
        setData(title: title, withImage: withImage, showBadge: showBadge)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI & Layout

extension STSingleFloatingButton {
    private func setLayout() {
        addSubviews(floatingButton, badgeView)
        
        floatingButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(54)
        }
        
        badgeView.snp.makeConstraints { make in
            make.top.equalTo(floatingButton.snp.top).offset(-10)
            make.trailing.equalTo(floatingButton.snp.trailing).offset(-16)
        }
    }

    private func setData(title: String, withImage: Bool, showBadge: Bool) {
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .clear
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 12)
        config.imagePadding = 4

        let attributes = Typography.heading4.attributedStringAttributes(foregroundColor: SemanticColor.Fg.Neutral.inverse)
        config.attributedTitle = AttributedString(NSAttributedString(string: title, attributes: attributes))

        if withImage {
            config.image = MDSIcon.trophyOutlined.image.withTintColor(SemanticColor.Fg.Neutral.inverse)
        }

        floatingButton.configuration = config

        if showBadge {
            badgeView.isHidden = false
        }
    }
}
