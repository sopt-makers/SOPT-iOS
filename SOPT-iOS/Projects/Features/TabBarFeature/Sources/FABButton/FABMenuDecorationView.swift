//
//  FABMenuDecorationView.swift
//  HomeFeature
//
//  Created by 성현주 on 11/30/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//


import UIKit

import DSKit

final class FABMenuDecorationView: UICollectionReusableView {
    
    // MARK: - UI Components
    private let backgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension FABMenuDecorationView {
    private func setLayout() {
        self.addSubviews(backgroundView)
        
        backgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
        }
    }
}
