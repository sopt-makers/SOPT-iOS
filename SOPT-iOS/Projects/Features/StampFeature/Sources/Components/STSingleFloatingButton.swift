//
//  STFloatingButton.swift
//  StampFeature
//
//  Created by 최주리 on 12/17/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class STSingleFloatingButton: UIView {

    // MARK: - Properties
    
    public lazy var buttonTapped = floatingButton.gesture().mapVoid().asDriver()
    
    // MARK: - UI Components
    
    private let floatingButton = UIButton().then {
        $0.layer.cornerRadius = 27
        $0.backgroundColor = DSKitAsset.Colors.white.color
        $0.titleLabel?.font = .SoptampFont.h2
    }
    
    private let badgeView = STBadgeView().then {
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
            make.width.equalTo(143)
            make.height.equalTo(54)
        }
        
        badgeView.snp.makeConstraints { make in
            make.top.equalTo(floatingButton.snp.top).offset(-10)
            make.trailing.equalTo(floatingButton.snp.trailing).offset(-16)
        }
    }

    private func setData(title: String, withImage: Bool, showBadge: Bool) {
        let attributedStr = NSMutableAttributedString(string: title)
        attributedStr.addAttribute(NSAttributedString.Key.kern, value: 0, range: NSMakeRange(0, attributedStr.length))
        attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: DSKitAsset.Colors.black.color, range: NSMakeRange(0, attributedStr.length))
        floatingButton.setAttributedTitle(attributedStr, for: .normal)
        
        if showBadge {
            badgeView.isHidden = false
            badgeView.setData(with: "New")
        }
        
        if withImage {
            floatingButton.setImage(DSKitAsset.Assets.icTrophy.image, for: .normal)
        }
    }
}
