//
//  ClapCountBadge.swift
//  StampFeature
//
//  Created by 최주리 on 10/20/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class ClapCountBadge: UIView {
    private let countLabel = UILabel().then {
        $0.text = "+1"
        $0.font = DSKitFontFamily.Suit.medium.font(size: 13)
        $0.textColor = DSKitAsset.Colors.white.color
    }
    
    init() {
        super.init(frame: .zero)
        
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ClapCountBadge {
    func setCount(_ count: Int) {
        countLabel.text = "+\(count)"
    }
}

// MARK: - UI & Layout

extension ClapCountBadge {
    private func setUI() {
        self.layer.cornerRadius = 8
        self.backgroundColor = DSKitAsset.Colors.orange100.color
    }
    
    private func setLayout() {
        self.addSubview(countLabel)
        
        countLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(2)
            $0.horizontalEdges.equalToSuperview().inset(7)
        }
    }
}
