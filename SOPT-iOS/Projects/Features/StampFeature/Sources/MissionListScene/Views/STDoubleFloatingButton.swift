//
//  STDoubleFloatingButton.swift
//  StampFeature
//
//  Created by 최주리 on 12/17/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import MDS

final class STDoubleFloatingButton: UIView {

    // MARK: - Properties
    
    public lazy var personalButtonTapped = personalRankButton.gesture().mapVoid().asDriver()
    public lazy var partButtonTapped = partRankButton.gesture().mapVoid().asDriver()
    
    // MARK: - UI Components
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    private lazy var personalRankButton = UIButton().then {
        let config = setButtonConfiguration(
            text: I18N.RankingList.personalRankingTitle,
            textColor: SemanticColor.Fg.Neutral.inverse,
            contentInsets: NSDirectionalEdgeInsets(top: 15, leading: 17, bottom: 15, trailing: 9)
        )

        $0.configuration = config
        $0.layer.backgroundColor = SemanticColor.Bg.Neutral.inverse.cgColor
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        $0.layer.cornerRadius = 54 / 2
        $0.clipsToBounds = true
    }

    private lazy var partRankButton = UIButton().then {
        let config = setButtonConfiguration(
            text: I18N.RankingList.partRankingTitle,
            textColor: SemanticColor.Fg.Neutral.bold,
            contentInsets: NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 15)
        )

        $0.configuration = config
        $0.layer.backgroundColor = SemanticColor.Bg.Layer.default.cgColor
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        $0.layer.cornerRadius = 54 / 2
        $0.clipsToBounds = true
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI & Layout

extension STDoubleFloatingButton {
    private func setLayout() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(personalRankButton, partRankButton)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        personalRankButton.snp.makeConstraints { make in
            make.width.equalTo(134.adjusted)
            make.height.equalTo(54)
        }

        partRankButton.snp.makeConstraints { make in
            make.width.equalTo(134.adjusted)
            make.height.equalTo(54)
        }
    }
    
    private func setButtonConfiguration(text: String, textColor: UIColor, contentInsets: NSDirectionalEdgeInsets) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()

        config.background.backgroundColor = .clear
        config.cornerStyle = .capsule
        config.contentInsets = contentInsets
        config.imagePadding = 10
        config.image = MDSIcon.trophyOutlined.image.withTintColor(textColor)
        config.baseForegroundColor = textColor

        let attributes = Typography.label1.attributedStringAttributes(foregroundColor: textColor)
        config.attributedTitle = AttributedString(NSAttributedString(string: text, attributes: attributes))

        return config
    }
}
