//
//  RankingCVC.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain
import DSKit

import SnapKit

final class RankingChartCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    
    // MARK: - UI Components
    
    private let sentenceLabel: UILabel = {
        let label = UILabel()
        label.text = "한마디 하겠습니다"
        label.setTypoStyle(.caption1)
        label.textColor = DSKitAsset.Colors.gray700.color
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let chartStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.spacing = 18.adjusted
        st.distribution = .fillEqually
        return st
    }()
    
    // MARK: - View Life Cycles
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layouts

extension RankingChartCVC {
    
    private func setLayout() {
        self.addSubviews(sentenceLabel, chartStackView)
        
        sentenceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(48.adjustedH)
            make.centerX.equalToSuperview()
        }
        
        [RectangleViewLevel.levelTwo, RectangleViewLevel.levelOne, RectangleViewLevel.levelThree].forEach { level in
            let rectangleView = ChartRectangleView.init(level: level)
            rectangleView.snp.makeConstraints { make in
                make.width.equalTo(90.adjusted)
            }
            chartStackView.addArrangedSubview(rectangleView)
        }
        
        chartStackView.snp.makeConstraints { make in
            make.top.equalTo(sentenceLabel.snp.bottom)
            make.height.equalTo(250.adjustedH)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension RankingChartCVC {
    
    public func setData(model: String) {
        
    }
}

