//
//  HomeCategoryTagLabel.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import MDS

final class HomeCategoryTagLabel: UILabel {
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension HomeCategoryTagLabel {
    func setUI() {
        self.setTypography(Typography.label4, textColor: SemanticColor.Fg.Brand.default, alignment: .center)
    }
}

// MARK: - Methods

extension HomeCategoryTagLabel {
    func setData(with text: String) {
        self.text = text
        self.setTypography(Typography.label4, textColor: SemanticColor.Fg.Brand.default, alignment: .center)
    }
    
    @discardableResult
    func setTitleColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
}
