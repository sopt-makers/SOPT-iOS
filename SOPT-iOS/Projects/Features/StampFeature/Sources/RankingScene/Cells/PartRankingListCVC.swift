//
//  PartRankingListCVC.swift
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

final class PartRankingListCVC: UICollectionViewCell, UICollectionViewRegisterable {

  // MARK: - Properties

  static var isFromNib: Bool = false

  // MARK: - UI Components

  private let rankLabel: UILabel = {
    let label = UILabel()
    label.font = DSKitFontFamily.Montserrat.bold.font(size: 30.adjusted)
    label.textColor = DSKitAsset.Colors.soptampGray500.color
    label.textAlignment = .center
    return label
  }()

  private let partNameLabel: UILabel = {
    let label = UILabel()
    label.setTypoStyle(.SoptampFont.h3)
    label.textColor = DSKitAsset.Colors.soptampGray800.color
    label.lineBreakMode = .byTruncatingTail
    label.setCharacterSpacing(0)
    return label
  }()

  private let scoreLabel: UILabel = {
    let label = UILabel()
    label.setTypoStyle(.SoptampFont.number2)
    label.textColor = DSKitAsset.Colors.soptampGray400.color
    return label
  }()

  // MARK: - View Life Cycles

  private override init(frame: CGRect) {
    super.init(frame: frame)
    self.setUI()
    self.setLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UI & Layouts

extension PartRankingListCVC {

  public func setUI() {
    self.backgroundColor = DSKitAsset.Colors.soptampGray50.color
    self.layer.cornerRadius = 8
  }

  private func setLayout() {
    self.addSubviews(rankLabel, partNameLabel, scoreLabel)

    rankLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(16.adjusted)
      make.width.greaterThanOrEqualTo(53.adjusted)
    }

    partNameLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(rankLabel.snp.trailing).offset(16.adjusted)
      make.width.lessThanOrEqualTo(157.adjusted)
    }

    scoreLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(20.adjusted)
    }
  }
}

// MARK: - Methods

extension PartRankingListCVC {

  public func setData(rank: Int, partName: String, score: Int) {
    rankLabel.text = String(rank)
    partNameLabel.text = partName
    scoreLabel.text = "\(score)점"
    scoreLabel.partFontChange(targetString: "점",
                              font: DSKitFontFamily.Pretendard.medium.font(size: 12))
    setDefaultRanking()
  }

  private func setDefaultRanking() {
    self.backgroundColor = DSKitAsset.Colors.soptampGray50.color
    self.layer.borderColor = nil
    self.layer.borderWidth = 0
    rankLabel.textColor = DSKitAsset.Colors.soptampGray500.color
    scoreLabel.textColor = DSKitAsset.Colors.soptampGray400.color
  }
}
