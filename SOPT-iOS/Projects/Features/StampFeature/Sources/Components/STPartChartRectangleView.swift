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

import SnapKit

public class STPartChartRectangleView: UIView {

  // MARK: - Properties

  public var rank: Int = 6
  public var partName: String = "파트"

  // MARK: - UI Components

  private let starRankView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.image = DSKitAsset.Assets.icStar.image.withRenderingMode(.alwaysTemplate)
    iv.tintColor = DSKitAsset.Colors.soptampPurple100.color
    return iv
  }()

  private let rankLabel: UILabel = {
    let label = UILabel()
    label.font = DSKitFontFamily.Montserrat.bold.font(size: 30)
    return label
  }()

  private let rectangleView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 8
    return view
  }()

  private let partNameLabel: UILabel = {
    let label = UILabel()
    label.setTypoStyle(.MDS.body3)
    label.textColor = .black
    label.lineBreakMode = .byTruncatingTail
    label.setCharacterSpacing(0)
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
    rankLabel.text = "\(rank)"
    partNameLabel.text = partName
    starRankView.isHidden = (rank > 3)

    if rank == 1 {
      rankLabel.textColor = DSKitAsset.Colors.soptampPurple300.color
      rectangleView.backgroundColor = DSKitAsset.Colors.soptampPurple200.color
      starRankView.image = DSKitAsset.Assets.icStar.image.withRenderingMode(.alwaysTemplate)
    } else if rank == 2 {
      rankLabel.textColor = DSKitAsset.Colors.soptampPink300.color
      rectangleView.backgroundColor = DSKitAsset.Colors.soptampPink200.color
      starRankView.image = nil
    } else if rank == 3 {
      rankLabel.textColor = DSKitAsset.Colors.soptampMint300.color
      rectangleView.backgroundColor = DSKitAsset.Colors.soptampMint200.color
      starRankView.image = nil
    } else {
      rankLabel.text = ""
      rectangleView.backgroundColor = DSKitAsset.Colors.gray300.color
    }
  }

  private func setLayout() {
    self.addSubviews(starRankView, rectangleView, partNameLabel)
    starRankView.addSubview(rankLabel)

    starRankView.snp.makeConstraints { make in
      make.bottom.equalTo(rectangleView.snp.top).offset(-13.adjusted)
      make.centerX.equalToSuperview()
      make.size.equalTo(50.adjusted)
    }

    rankLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().inset(3)
    }

    rectangleView.snp.makeConstraints { make in
      make.bottom.equalTo(partNameLabel.snp.top).offset(-10.adjustedH)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(self.calculateRectangleViewHeight())
    }

    partNameLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview()
      make.width.lessThanOrEqualToSuperview()
    }
  }

  private func calculateRectangleViewHeight() -> CGFloat {
    return 27.f * (7 - rank).f
  }
}

extension STPartChartRectangleView {
  public func setData(rank: Int, partName: String) {
    print(rank)
    self.rank = rank
    self.partName = partName
    self.setUI()
  }
}

extension STPartChartRectangleView {
  static func == (left: STPartChartRectangleView, right: STPartChartRectangleView) -> Bool {
    return left.rank == right.rank
  }
}

