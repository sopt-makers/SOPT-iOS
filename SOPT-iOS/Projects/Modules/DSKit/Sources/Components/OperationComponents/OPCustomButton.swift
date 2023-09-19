//
//  OPCustomButton.swift
//  DSKit
//
//  Created by 김영인 on 2023/04/17.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core

public class OPCustomButton: UIButton {
    
    // MARK: - Init
    
    public init() {
        super.init(frame: .zero)
        
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI

extension OPCustomButton {
    public func setUI() {
        self.setTitleColor(DSKitAsset.Colors.black100.color, for: .normal)
        self.setTitleColor(DSKitAsset.Colors.gray60.color, for: .disabled)
        
        self.setBackgroundColor(DSKitAsset.Colors.white100.color, for: .normal)
        self.setBackgroundColor(DSKitAsset.Colors.black40.color, for: .disabled)
        
        self.layer.cornerRadius = 10
    }
}
