//
//  ToolTipView.swift
//  DSKit
//
//  Created by 장석우 on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

public class ToolTipView: UIView {
    
    public struct Configuration {
        var tipWidth: Double
        var tipHeight: Double
        
        public init(tipWidth: Double = 13, tipHeight: Double = 10) {
            self.tipWidth = tipWidth
            self.tipHeight = tipHeight
        }
    }
    
    public var configuration: Configuration {
        didSet {
            updatePath()
        }
    }
    
    override public var backgroundColor: UIColor? {
        didSet {
            shape.fillColor = backgroundColor?.cgColor
        }
    }
    
    private lazy var shape = CAShapeLayer()
    
    public let contentView: UIView = UIView()
    
    public override func layoutSubviews() {
        updatePath()
    }
    
    public init(
        configuration: Configuration = Configuration()
    ) {
        self.configuration = configuration
        
        super.init(frame: .zero)
        
        self.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.layer.insertSublayer(shape, at: 0)
        self.layer.masksToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func updatePath() {
        let path = CGMutablePath()
        
        let tipCenter = self.frame.width / 2.0
        let tipStartX = tipCenter - configuration.tipWidth / 2
        let tipEndX = tipStartX + configuration.tipWidth
    
        path.move(to: CGPoint(x: tipStartX, y: self.bounds.maxY))
        path.addLine(to: CGPoint(x: tipCenter, y: self.bounds.maxY + configuration.tipHeight))
        path.addLine(to: CGPoint(x: tipEndX, y: self.bounds.maxY))
        path.addLine(to: CGPoint(x: tipStartX, y: self.bounds.maxY))
        
        shape.path = path
    }

}
