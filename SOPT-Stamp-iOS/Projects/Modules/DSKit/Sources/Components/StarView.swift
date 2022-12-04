//
//  StarView.swift
//  DSKit
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core

import SnapKit

public enum StarViewLevel {
    case levelOne
    case levelTwo
    case levelThree
}

public class StarView: UIView {
    
    // MARK: - Properties
    
    private var spacing: CGFloat = 0
    private var starScale: CGFloat = 15
    private var starImageArray: [UIImageView] = []
    private var starDefaultColor = DSKitAsset.Colors.gray300.color
    
    // MARK: - UI Components
    
    private lazy var starStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.distribution = .fillEqually
        return st
    }()
    
    // MARK: View Life Cycle
    
    public convenience init(starScale: CGFloat, spacing: CGFloat = 0, level: StarViewLevel) {
        self.init()
        
        self.starScale = starScale
        self.spacing = spacing
        setLayout()
        setStarStackView(level: level)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension StarView {
    
    private func setLayout() {
        self.addSubviews(starStackView)
        starStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setStarStackView(level: StarViewLevel) {
        starStackView.spacing = self.spacing
        
        for starNumber in 1...3 {
            let imageView = UIImageView()
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(self.starScale)
            }
            imageView.contentMode = .scaleToFill
            imageView.image = DSKitAsset.Assets.icStar.image.withRenderingMode(.alwaysTemplate)
            starStackView.addArrangedSubviews(imageView)
            starImageArray.append(imageView)
            
            if level == .levelOne && starNumber <= 1 {
                imageView.tintColor = DSKitAsset.Colors.pink300.color
            } else if level == .levelTwo && starNumber <= 2 {
                imageView.tintColor =  DSKitAsset.Colors.purple300.color
            } else if level == .levelThree {
                imageView.tintColor = DSKitAsset.Colors.mint300.color
            } else {
                imageView.tintColor = starDefaultColor
            }
        }
    }
    
    public func changeStarLevel(level: StarViewLevel) {
        for starNumber in 1...3 {
            if level == .levelOne && starNumber <= 1 {
                self.starImageArray[starNumber-1].tintColor = DSKitAsset.Colors.pink300.color
            } else if level == .levelTwo && starNumber <= 2 {
                self.starImageArray[starNumber-1].tintColor =  DSKitAsset.Colors.purple300.color
            } else if level == .levelThree {
                self.starImageArray[starNumber-1].tintColor = DSKitAsset.Colors.mint300.color
            } else {
                self.starImageArray[starNumber-1].tintColor = starDefaultColor
            }
        }
    }
}
