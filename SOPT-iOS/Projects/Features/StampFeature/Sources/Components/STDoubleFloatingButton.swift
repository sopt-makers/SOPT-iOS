//
//  STDoubleFloatingButton.swift
//  StampFeature
//
//  Created by 최주리 on 12/17/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

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
        bt.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        bt.layer.cornerRadius = 27.adjustedH
        bt.setBackgroundColor(DSKitAsset.Colors.white.color, for: .normal)
        bt.setImage(DSKitAsset.Assets.icTrophy.image.withRenderingMode(.alwaysTemplate).withTintColor(DSKitAsset.Colors.white.color), for: .normal)
        bt.setImage(DSKitAsset.Assets.icTrophy.image.withRenderingMode(.alwaysTemplate).withTintColor(DSKitAsset.Colors.white.color), for: .highlighted)
        bt.setImage(DSKitAsset.Assets.icTrophy.image.withRenderingMode(.alwaysTemplate).withTintColor(DSKitAsset.Colors.gray200.color), for: .selected)
        bt.tintColor = DSKitAsset.Colors.black.color
        bt.titleLabel?.font = .SoptampFont.h2
        let attributedStr = NSMutableAttributedString(string: I18N.RankingList.personalRankingTitle)
        attributedStr.addAttribute(NSAttributedString.Key.kern, value: 0, range: NSMakeRange(0, attributedStr.length))
        attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: DSKitColors.Color.black, range: NSMakeRange(0, attributedStr.length))
        bt.setAttributedTitle(attributedStr, for: .normal)
        bt.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        bt.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return bt
    }()
    
    private lazy var partRankButton: UIButton = {
        let bt = UIButton()
        bt.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        bt.layer.cornerRadius = 27.adjustedH
        bt.setBackgroundColor(DSKitAsset.Colors.black.color, for: .normal)
        bt.setBackgroundColor(DSKitAsset.Colors.black.color.withAlphaComponent(0.8), for: .selected)
        bt.setImage(DSKitAsset.Assets.icTrophy.image.withRenderingMode(.alwaysTemplate), for: .normal)
        bt.setImage(DSKitAsset.Assets.icTrophy.image.withRenderingMode(.alwaysTemplate).withTintColor(DSKitAsset.Colors.gray200.color), for: .highlighted)
        bt.tintColor = .white
        bt.titleLabel?.font = .SoptampFont.h2
        let attributedStr = NSMutableAttributedString(string: I18N.RankingList.partRankingTitle)
        attributedStr.addAttribute(NSAttributedString.Key.kern, value: 0, range: NSMakeRange(0, attributedStr.length))
        attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, attributedStr.length))
        bt.setAttributedTitle(attributedStr, for: .normal)
        bt.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        bt.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
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
