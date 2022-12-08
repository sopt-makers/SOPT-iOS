//
//  CustomVisualEffectView.swift
//  DSKit
//
//  Created by 양수빈 on 2022/12/07.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

public class CustomVisualEffectView: UIVisualEffectView {
    
    // MARK: - Properties
    
    private var theEffect: UIVisualEffect
    private var customIntensity: CGFloat
    private var animator: UIViewPropertyAnimator?
    
    // MARK: - View Life Cycles
    
    public init(effect: UIVisualEffect, intensity: CGFloat) {
        self.theEffect = effect
        self.customIntensity = intensity
        super.init(effect: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        nil
    }
    
    deinit {
        animator?.stopAnimation(true)
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        effect = nil
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in
            self.effect = theEffect
        }
        animator?.fractionComplete = customIntensity
    }
}
