//
//  createGradientLayer.swift
//  Core
//
//  Created by devxsby on 2023/09/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

public extension UIView {
    
    @frozen
    enum GradientDirection {
        case vertical
        case horizontal
    }
    
    @discardableResult
    func createGradientLayer(colors: [UIColor], direction: GradientDirection) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors.map { $0.cgColor }
        
        switch direction {
        case .vertical:
            gradient.startPoint = CGPoint(x: 0.5, y: 0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1)
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        }
        
        layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}
