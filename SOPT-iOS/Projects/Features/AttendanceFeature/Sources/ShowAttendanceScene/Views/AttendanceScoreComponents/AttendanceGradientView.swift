//
//  GradientView.swift
//  AttendanceFeature
//
//  Created by 김영인 on 2023/10/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import MDS

import SnapKit

class AttendanceGradientView: UIView {
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if self == hitView { return nil }
        return hitView
    }
    
    // MARK: - UI
    
    func setUI() {
        createGradientLayer(colors: [.clear, SemanticColor.Bg.Layer.basement], direction: .vertical)
    }
}
