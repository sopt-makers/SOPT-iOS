//
//  STDoubleFloatingButton.swift
//  StampFeature
//
//  Created by 최주리 on 12/17/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

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
            textColor: DSKitColors.Color.black
        )
        
        $0.configuration = config
        $0.layer.backgroundColor = DSKitAsset.Colors.white.color.cgColor
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        $0.layer.cornerRadius = 27
    }
    
    private lazy var partRankButton = UIButton().then {
        let config = setButtonConfiguration(
            text: I18N.RankingList.partRankingTitle,
            textColor: DSKitColors.Color.white
        )
        
        $0.configuration = config
        $0.layer.backgroundColor = DSKitAsset.Colors.black.color.cgColor
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        $0.layer.cornerRadius = 27
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
            make.width.equalTo(143.adjusted)
            make.height.equalTo(54.adjustedH)
        }
        
        partRankButton.snp.makeConstraints { make in
            make.width.equalTo(143.adjusted)
            make.height.equalTo(54.adjustedH)
        }
    }
    
    private func setButtonConfiguration(text: String, textColor: UIColor) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        
        config.background.backgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -15, bottom: 0, trailing: 0)
        config.imagePadding = 10
        config.image = DSKitAsset.Assets.icTrophy.image.withRenderingMode(.alwaysTemplate)
        config.baseForegroundColor = textColor
        
        var attributedStr = AttributedString(text)
        attributedStr.font = .SoptampFont.h2
        attributedStr.foregroundColor = textColor
        config.attributedTitle = attributedStr
        
        return config
    }
}
