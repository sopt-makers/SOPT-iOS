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
    public var balloonTapped: ((RankingModel) -> Void)?
    public var models: [RankingModel] = []
    
    // MARK: - UI Components
    
    private var balloonViews: [STSpeechBalloonView] = []
    
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
            let rectangleView = STChartRectangleView.init(level: level)
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
    
    private func setGesture(_ view: STChartRectangleView) {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showBalloonForView(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func showBalloonForView(_ sender: UITapGestureRecognizer) {
        guard let senderView = sender.view as? STChartRectangleView else { return }
        for (chart, balloon) in zip(chartStackView.arrangedSubviews, balloonViews) {
            guard let chartView = chart as? STChartRectangleView else { return }
            balloon.isHidden = (chartView != senderView)
        }
    }
}

// MARK: - Methods

extension RankingChartCVC {
    
    private func prepareCell() {
        balloonViews.forEach {
            $0.removeFromSuperview()
        }
        balloonViews.removeAll()
    }
    
    public func setData(model: RankingChartModel) {
        
        // 데이터 바인딩을 위한 모델 순서 재정렬
        let arrangedModel = [model.ranking[1], model.ranking[0], model.ranking[2]]
        self.models = arrangedModel
        
        self.setSpeechBalloonViews(balloonModels: arrangedModel)
        self.setChartData(chartRectangleModel: arrangedModel)
    }
    
    private func setSpeechBalloonViews(balloonModels: [RankingModel]) {
        
        // 말풍선 text 설정
        for (index, model) in balloonModels.enumerated() {
            var balloonView: STSpeechBalloonView
            if index == 0 {
                balloonView = STSpeechBalloonView.init(level: .rankTwo, sentence: model.sentence)
                balloonView.isHidden = true
            } else if index == 1 {
                balloonView = STSpeechBalloonView.init(level: .rankOne, sentence: model.sentence)
            } else {
                balloonView = STSpeechBalloonView.init(level: .rankThree, sentence: model.sentence)
                balloonView.isHidden = true
            }
            balloonViews.append(balloonView)
            self.setBalloonGesture(balloonView)
        }
        
        balloonViews.forEach {
            self.addSubview($0)
            
            $0.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(48.adjustedH)
                make.width.equalToSuperview()
                make.centerX.equalToSuperview()
            }
        }
    }
    
    private func setBalloonGesture(_ view: STSpeechBalloonView) {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tappedGetBalloonModel(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func tappedGetBalloonModel(_ sender: UITapGestureRecognizer) {
        guard let senderView = sender.view as? STSpeechBalloonView,
              let balloonIndex = balloonViews.firstIndex(of: senderView) else { return }
        let model = models[balloonIndex]
        _ = self.balloonTapped?(model)
    }
    
    private func setChartData(chartRectangleModel: [RankingModel]) {
        for (index, rectangle) in chartStackView.subviews.enumerated() {
            guard let chartRectangle = rectangle as? STChartRectangleView else { return }
            chartRectangle.setData(score: chartRectangleModel[index].score,
                                   username: chartRectangleModel[index].username)
        }
    }
}
