//
//  ChartRectangleView.swift
//  DSKit
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

import SnapKit

public enum RectangleViewRank {
  case rankOne
  case rankTwo
  case rankThree
}

extension RectangleViewRank {
  var rectangleHeight: CGFloat {
    switch self {
    case .rankOne:
      return 150.adjustedH
    case .rankTwo:
      return 110.adjustedH
    case .rankThree:
      return 70.adjustedH
    }
  }
}

public class STChartRectangleView: UIView {
  
  // MARK: - Properties
  
  public var viewLevel = RectangleViewRank.rankOne
  
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
  
  private let scoreLabel: UILabel = {
    let label = UILabel()
    label.text = "100점"
    label.setTypoStyle(.SoptampFont.number2)
    label.partFontChange(targetString: "점", font: DSKitFontFamily.Pretendard.medium.font(size: 12))
    return label
  }()
  
  private let rightChevronImageView = UIImageView().then {
    $0.image = DSKitAsset.Assets.chevronRight.image.withRenderingMode(.alwaysTemplate)
    $0.tintColor = DSKitAsset.Colors.gray600.color
  }
  
  private lazy var usernameContainerView = UIView().then {
    $0.layer.cornerRadius = 16.f
    $0.backgroundColor = self.pointColor
  }

  private lazy var usernameStackView = UIStackView().then {
    $0.spacing = 0.f
    $0.alignment = .center
  }
  
  private let usernameLabel: UILabel = {
    let label = UILabel()
    label.text = "뉴비"
    label.setTypoStyle(.SoptampFont.subtitle3)
    label.textColor = DSKitAsset.Colors.gray800.color
    label.lineBreakMode = .byCharWrapping
    label.setCharacterSpacing(0)
    return label
  }()
  
  // MARK: View Life Cycle
  
  public init(level: RectangleViewRank) {
    self.init()
    
    self.viewLevel = level
    setUI()
    setLayout()
  }
  
  private override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private var pointColor: UIColor {
    switch self.viewLevel {
    case .rankOne: return DSKitAsset.Colors.soptampPurple200.color
    case .rankTwo: return DSKitAsset.Colors.soptampPink200.color
    case .rankThree: return DSKitAsset.Colors.soptampMint200.color
    }
  }
}

// MARK: - Methods

// MARK: - UI & Layouts

extension STChartRectangleView {
  private func setUI() {
    self.rectangleView.backgroundColor = self.pointColor
    
    switch viewLevel {
    case .rankOne:
      rankLabel.text = "1"
      rankLabel.textColor = DSKitAsset.Colors.soptampPurple300.color
      setScoreLabel(by: DSKitAsset.Colors.soptampPurple300.color)
    case .rankTwo:
      rankLabel.text = "2"
      rankLabel.textColor = DSKitAsset.Colors.soptampPink300.color
      setScoreLabel(by: DSKitAsset.Colors.soptampPink300.color)
    case .rankThree:
      rankLabel.text = "3"
      rankLabel.textColor = DSKitAsset.Colors.soptampMint300.color
      setScoreLabel(by: DSKitAsset.Colors.soptampMint300.color)
    }
  }
  
  private func setScoreLabel(by color: UIColor) {
    scoreLabel.textColor = color
  }
  
  private func setLayout() {
    self.usernameContainerView.addSubview(self.usernameStackView)
    
    self.usernameStackView.addArrangedSubviews(self.usernameLabel, self.rightChevronImageView)
    self.usernameStackView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(6.f)
      $0.top.bottom.equalToSuperview().inset(4.f)
    }
    
    self.rightChevronImageView.snp.makeConstraints { $0.width.height.equalTo(16.f) }
    
    if case .rankOne = viewLevel {
      self.addSubviews(starRankView, rectangleView, usernameContainerView)
      
      starRankView.addSubview(rankLabel)
      
      starRankView.snp.makeConstraints { make in
        make.top.equalToSuperview().inset(8.adjustedH)
        make.bottom.equalTo(rectangleView.snp.top).offset(-13.adjusted)
        make.centerX.equalToSuperview()
        make.size.equalTo(50.adjusted)
      }
      
      usernameContainerView.snp.makeConstraints { make in
        make.centerX.equalToSuperview()
        make.height.equalTo(32.f)
        make.centerY.equalToSuperview().inset(3)
      }
      
      rankLabel.snp.makeConstraints { make in
        make.center.equalToSuperview()
      }
    } else {
      self.addSubviews(rankLabel, rectangleView, usernameContainerView)
      
      rankLabel.snp.makeConstraints { make in
        make.bottom.equalTo(rectangleView.snp.top).offset(-8.adjusted)
        make.centerX.equalToSuperview()
      }
    }
    
    rectangleView.addSubview(scoreLabel)
    
    scoreLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    rectangleView.snp.makeConstraints { make in
      make.bottom.equalTo(usernameContainerView.snp.top).offset(-10.adjustedH)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(self.viewLevel.rectangleHeight)
    }
    
    usernameContainerView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview()
      make.height.equalTo(32.f)
      make.width.lessThanOrEqualToSuperview()
    }
  }
}

extension STChartRectangleView {
  public func signalForClickUserName() -> Driver<Void> {
    return self.usernameContainerView.gesture().mapVoid().asDriver()
  }
  
  public func setData(score: Int, username: String) {
    self.usernameLabel.text = username
    self.scoreLabel.text = "\(score)점"
    self.scoreLabel.partFontChange(targetString: "점",
                                   font: DSKitFontFamily.Pretendard.medium.font(size: 12))
  }
}

extension STChartRectangleView {
  static func == (left: STChartRectangleView, right: STChartRectangleView) -> Bool {
    return left.viewLevel == right.viewLevel
  }
}
