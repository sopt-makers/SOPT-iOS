//
//  MainServiceCVC.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class MainServiceCVC: UICollectionViewCell {
    
    // MARK: - initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layouts

extension MainServiceCVC {
    private func setUI() {
        self.backgroundColor = [UIColor.red, .blue, UIColor.brown, UIColor.lightGray, UIColor.green, UIColor.purple].randomElement()
    }
    
    private func setLayout() {
        
    }
}
