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
    
    private var baloonViews: [SpeechBalloonView] = []
    
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
        self.setChartViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.prepareCell()
    }
}

// MARK: - UI & Layouts

extension RankingChartCVC {
    
    private func setChartViews() {
        self.addSubviews(chartStackView)
        
        [RectangleViewRank.rankTwo, RectangleViewRank.rankOne, RectangleViewRank.rankThree].forEach { level in
            let rectangleView = ChartRectangleView.init(level: level)
            rectangleView.snp.makeConstraints { make in
                make.width.equalTo(90.adjusted)
            }
            chartStackView.addArrangedSubview(rectangleView)
            self.setGesture(rectangleView)
        }
        
        chartStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(48.adjustedH)
            make.height.equalTo(250.adjustedH)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setGesture(_ view: ChartRectangleView) {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showBalloonForView(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func showBalloonForView(_ sender: UITapGestureRecognizer) {
        guard let senderView = sender.view as? ChartRectangleView else { return }
        for (chart, balloon) in zip(chartStackView.arrangedSubviews, baloonViews) {
            guard let chartView = chart as? ChartRectangleView else { return }
            balloon.isHidden = (chartView != senderView)
        }
    }
}

// MARK: - Methods

extension RankingChartCVC {
    
    private func prepareCell() {
        baloonViews.forEach {
            $0.removeFromSuperview()
        }
        baloonViews.removeAll()
    }
    
    public func setData(model: RankingChartModel) {
        
        let sentences = model.ranking.map { $0.sentence }
        
        for (index, sentence) in sentences.enumerated() {
            var baloonView: SpeechBalloonView
            if index == 0 {
                baloonView = SpeechBalloonView.init(level: .rankTwo, sentence: sentence)
                baloonView.isHidden = true
            } else if index == 1 {
                baloonView = SpeechBalloonView.init(level: .rankOne, sentence: sentence)
            } else {
                baloonView = SpeechBalloonView.init(level: .rankThree, sentence: sentence)
                baloonView.isHidden = true
            }
            baloonViews.append(baloonView)
        }
        
        baloonViews.forEach {
            self.addSubview($0)
            
            $0.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(48.adjustedH)
                make.width.equalToSuperview()
                make.centerX.equalToSuperview()
            }
        }
    }
}
