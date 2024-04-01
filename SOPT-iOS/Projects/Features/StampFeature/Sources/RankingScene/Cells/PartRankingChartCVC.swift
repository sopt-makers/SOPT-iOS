//
//  PartRankingChartCVC.swift
//  StampFeature
//
//  Created by Aiden.lee on 2024/04/01.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain
import DSKit

import SnapKit

final class PartRankingChartCVC: UICollectionViewCell, UICollectionViewRegisterable {
  static var isFromNib: Bool = false

  // MARK: - Properties

  public var models: [RankingModel] = []

  // MARK: - UI Components

  private let chartStackView: UIStackView = {
    let st = UIStackView()
    st.axis = .horizontal
    st.spacing = 7
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
}

// MARK: - UI & Layouts

extension PartRankingChartCVC {

  private func setChartViews() {
    self.addSubviews(chartStackView)

    (1...6).forEach { rank in
      let rectangleView = STPartChartRectangleView(rank: rank)
      rectangleView.snp.makeConstraints { make in
        make.width.greaterThanOrEqualTo(40)
      }
      chartStackView.addArrangedSubview(rectangleView)
    }

    chartStackView.snp.makeConstraints { make in
      make.height.equalTo(250)
      make.top.leading.trailing.bottom.equalToSuperview()
    }
  }
}

// MARK: - Methods

extension PartRankingChartCVC {
  public func setData(model: RankingChartModel) {
    let models = model.ranking
    self.models = models

    self.setChartData(chartRectangleModel: models)
  }

  private func setChartData(chartRectangleModel: [RankingModel]) {
    for (index, rectangle) in chartStackView.arrangedSubviews.enumerated() {
      guard let chartRectangle = rectangle as? STPartChartRectangleView else { return }
      guard let model = chartRectangleModel[safe: index] else { return }
      chartRectangle.setData(rank: model.score, partName: model.username)
    }
  }
}
