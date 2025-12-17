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
        $0.spacing = 0.f
    }
    
    private lazy var personalRankButton: UIButton = {
        let bt = UIButton()
        var config = UIButton.Configuration.plain()
        
        config.background.backgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -15, bottom: 0, trailing: 0)
        config.imagePadding = 10
        config.baseForegroundColor = DSKitAsset.Colors.black.color
        config.image = DSKitAsset.Assets.icTrophy.image
        
        var attributedStr = AttributedString(I18N.RankingList.personalRankingTitle)
        attributedStr.font = .SoptampFont.h2
        attributedStr.foregroundColor = DSKitColors.Color.black
        attributedStr.kern = 0
        config.attributedTitle = attributedStr
        
        bt.configuration = config
        bt.layer.backgroundColor = DSKitAsset.Colors.white.color.cgColor
        bt.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        bt.layer.cornerRadius = 27
        
        return bt
    }()
    
    private lazy var partRankButton: UIButton = {
        let bt = UIButton()
        var config = UIButton.Configuration.plain()
        
        config.background.backgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -15, bottom: 0, trailing: 0)
        config.imagePadding = 10
        config.baseForegroundColor = DSKitAsset.Colors.black.color
        config.image = DSKitAsset.Assets.icTrophy.image.withRenderingMode(.alwaysTemplate)
        config.baseForegroundColor = DSKitColors.Color.white
        
        var attributedStr = AttributedString(I18N.RankingList.partRankingTitle)
        attributedStr.font = .SoptampFont.h2
        attributedStr.foregroundColor = DSKitColors.Color.white
        attributedStr.kern = 0
        config.attributedTitle = attributedStr
        
        bt.configuration = config
        bt.layer.backgroundColor = DSKitAsset.Colors.black.color.cgColor
        bt.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        bt.layer.cornerRadius = 27
        
        return bt
    }()
    
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
}
