//
//  STPartChartRectangleView.swift
//  StampFeature
//
//  Created by Aiden.lee on 2024/04/01.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit
import MDS

import SnapKit

public class STPartChartRectangleView: UIView {

  // MARK: - Properties

  public var rank: Int = 6
  public var partName: String = "파트"

  // MARK: - UI Components

  private let starRankView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.image = DSKitAsset.Assets.icBigStar.image.withRenderingMode(.alwaysTemplate)
    iv.tintColor = DSKitAsset.Colors.soptampPink300.color
    return iv
  }()

  private let rankLabel: UILabel = UILabel()

  private let rectangleView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = BaseRadius.Base.r8
    return view
  }()

  private let partNameLabel: UILabel = {
    let label = UILabel()
    label.lineBreakMode = .byTruncatingTail
    return label
  }()

  // MARK: View Life Cycle

  public init(rank: Int) {
    self.init()
    self.rank = rank
    setUI()
    setLayout()
  }

  private override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UI & Layouts

extension STPartChartRectangleView {

  private func setUI() {
    partNameLabel.text = partName
    partNameLabel.setTypography(Typography.label3,
                                textColor: SemanticColor.Fg.Neutral.default)
    starRankView.isHidden = (rank > 3)

    if rank == 1 {
      rankLabel.text = "\(rank)"
      rankLabel.setTypography(Typography.heading2,
                              textColor: SemanticColor.Fg.Neutral.bold)
      rectangleView.backgroundColor = DSKitAsset.Colors.soptampPink300.color
      starRankView.image = DSKitAsset.Assets.icBigStar.image.withRenderingMode(.alwaysTemplate)
    } else if rank == 2 {
      rankLabel.text = "\(rank)"
      rankLabel.setTypography(Typography.heading2,
                              textColor: DSKitAsset.Colors.green300.color)
      rectangleView.backgroundColor = DSKitAsset.Colors.green300.color
      starRankView.image = nil
    } else if rank == 3 {
      rankLabel.text = "\(rank)"
      rankLabel.setTypography(Typography.heading2,
                              textColor: DSKitAsset.Colors.soptampPurple300.color)
      rectangleView.backgroundColor = DSKitAsset.Colors.soptampPurple300.color
      starRankView.image = nil
    } else {
      rankLabel.text = ""
      rankLabel.isHidden = true
      rectangleView.backgroundColor = SemanticColor.Bg.Neutral.default
    }
  }

  private func setLayout() {
    self.addSubviews(starRankView, rectangleView, partNameLabel)
    starRankView.addSubview(rankLabel)

    starRankView.snp.makeConstraints { make in
      make.bottom.equalTo(rectangleView.snp.top).offset(-4)
      make.centerX.equalToSuperview()
      make.size.equalTo(50.adjusted)
    }

    rankLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }

    rectangleView.snp.makeConstraints { make in
      make.bottom.equalTo(partNameLabel.snp.top).offset(-8.adjustedH)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(self.calculateRectangleViewHeight())
    }

    partNameLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview()
      make.width.lessThanOrEqualToSuperview()
    }
  }

  private func updateLayout() {
    rectangleView.snp.updateConstraints { make in
      make.height.equalTo(self.calculateRectangleViewHeight())
    }
  }

  private func calculateRectangleViewHeight() -> CGFloat {
    return 27.f * (7 - rank).f
  }
}

extension STPartChartRectangleView {
  public func setData(rank: Int, partName: String) {
    self.rank = rank
    self.partName = partName
    self.setUI()
    self.updateLayout()
  }
}

extension STPartChartRectangleView {
  static func == (left: STPartChartRectangleView, right: STPartChartRectangleView) -> Bool {
    return left.rank == right.rank
  }
}

