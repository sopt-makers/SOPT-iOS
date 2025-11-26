//
//  SoptlogSectionBackgroundDecorationView.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class SoptlogSectionBackgroundDecorationView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray900.color
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = false
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

// MARK: - UI & Layout

extension SoptlogSectionBackgroundDecorationView {
    private func setLayout() {
        self.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
        }
    }
}
