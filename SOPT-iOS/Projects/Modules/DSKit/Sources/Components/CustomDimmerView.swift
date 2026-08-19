//
//  CustomDimmerView.swift
//  DSKit
//
//  Created by 양수빈 on 2022/12/07.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core
import MDS

public class CustomDimmerView: UIView {
    
    // MARK: - Properties
    private var view: UIView?
    
    // MARK: - UI Component
    private let blurEffect = UIBlurEffect(style: .light)
    private lazy var blurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.1)
    private let dimmerView = UIView()
    
    // MARK: - Initialize
    
    public init(_ vc: UIViewController) {
        super.init(frame: .zero)
        self.view = vc.view
        setViews()
    }
    
    public init(_ view: UIView) {
        super.init(frame: .zero)
        self.view = view
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomDimmerView {
    private func setViews() {
        dimmerView.backgroundColor = SemanticColor.Bg.Dim.default
        dimmerView.frame = self.view?.frame ?? CGRect()
        blurEffectView.frame = self.view?.frame ?? CGRect()
        self.addSubviews(blurEffectView, dimmerView)
    }
}
