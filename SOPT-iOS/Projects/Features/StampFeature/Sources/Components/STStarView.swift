//
//  StarView.swift
//  DSKit
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit
import MDS

import SnapKit

public class STStarView: UIView {

    // MARK: - Properties

    private var spacing: CGFloat = 0
    private var starScale: CGFloat = 15
    private var starImageArray: [UIImageView] = []
    private var starDefaultColor = SemanticColor.Fg.Neutral.ghost
    
    // MARK: - UI Components
    
    private lazy var starStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.distribution = .fillEqually
        return st
    }()
    
    // MARK: View Life Cycle
    
    public init(starScale: CGFloat = 15, spacing: CGFloat = 10, level: StarViewLevel) {
        self.init()
        
        self.starScale = starScale
        self.spacing = spacing
        setLayout()
        setStarStackView(level)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension STStarView {
    
    private func setLayout() {
        self.addSubviews(starStackView)
        
        starStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setStarStackView(_ level: StarViewLevel) {
        starStackView.spacing = self.spacing
        
        (1...3).forEach { _ in
            let imageView = UIImageView()
            imageView.snp.makeConstraints { make in
                make.size.equalTo(self.starScale)
            }
            imageView.contentMode = .scaleToFill
            imageView.image = DSKitAsset.Assets.icStar.image.withRenderingMode(.alwaysTemplate)
            
            starStackView.addArrangedSubview(imageView)
            starImageArray.append(imageView)
        }
        setStarColor(level: level)
    }
    
    public func setStarColor(level: StarViewLevel) {
        let cellType = MissionListCellType.mission(level: level, completed: false)
        
        for (index, imageView) in starImageArray.enumerated() {
            imageView.tintColor = index < level.rawValue ? cellType.starColor : starDefaultColor
        }
    }
}
