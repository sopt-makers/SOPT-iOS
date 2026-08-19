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
import MDS

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

  private let scoreView = STRankingScoreView()
  
  private let rightChevronImageView = UIImageView().then {
      $0.image = MDSIcon.chevronRightOutlined.image.withTintColor(SemanticColor.Fg.Neutral.default)
  }
  
  private lazy var usernameContainerView = UIView().then {
    $0.layer.cornerRadius = BaseRadius.Base.full
    $0.backgroundColor = SemanticColor.Bg.Neutral.ghost
  }

  private lazy var usernameStackView = UIStackView().then {
    $0.spacing = 0.f
    $0.alignment = .center
  }
  
  private let usernameLabel: UILabel = {
    let label = UILabel()
    label.lineBreakMode = .byCharWrapping
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
    case .rankOne: return DSKitAsset.Colors.soptampPink300.color
    case .rankTwo: return DSKitAsset.Colors.green300.color
    case .rankThree: return DSKitAsset.Colors.soptampPurple300.color
    }
  }
}

// MARK: - Methods

// MARK: - UI & Layouts

extension STChartRectangleView {
  private func setUI() {
    self.rectangleView.backgroundColor = self.pointColor
    self.rightChevronImageView.tintColor = pointColor

    switch viewLevel {
    case .rankOne:
      rankLabel.text = "1"
      rankLabel.setTypography(Typography.heading2,
                              textColor: SemanticColor.Fg.Neutral.bold)
    case .rankTwo:
      rankLabel.text = "2"
      rankLabel.setTypography(Typography.heading2,
                              textColor: pointColor)
    case .rankThree:
      rankLabel.text = "3"
      rankLabel.setTypography(Typography.heading2,
                              textColor: pointColor)
    }
  }
  
  private func setLayout() {
    self.usernameContainerView.addSubview(self.usernameStackView)
    
    self.usernameStackView.addArrangedSubviews(self.usernameLabel, self.rightChevronImageView)
    self.usernameStackView.snp.makeConstraints {
        $0.leading.equalToSuperview().inset(BaseSpacing.Base.s6)
        $0.trailing.equalToSuperview().inset(BaseSpacing.Base.s2)
        $0.directionalVerticalEdges.equalToSuperview().inset(BaseSpacing.Base.s8)
    }
    
    self.rightChevronImageView.snp.makeConstraints {
        $0.size.equalTo(16)
    }
    
    if case .rankOne = viewLevel {
      self.addSubviews(starRankView, rectangleView, usernameContainerView)
      
      starRankView.addSubview(rankLabel)
      
      starRankView.snp.makeConstraints { make in
        make.top.equalToSuperview().inset(8.adjustedH)
        make.bottom.equalTo(rectangleView.snp.top)
        make.centerX.equalToSuperview()
        make.size.equalTo(50.adjusted)
      }

      rankLabel.snp.makeConstraints { make in
        make.center.equalToSuperview()
      }
    } else {
      self.addSubviews(rankLabel, rectangleView, usernameContainerView)

      rankLabel.snp.makeConstraints { make in
        make.bottom.equalTo(rectangleView.snp.top).offset(-2.adjusted)
        make.centerX.equalToSuperview()
      }
    }
    
    rectangleView.addSubview(scoreView)

    scoreView.snp.makeConstraints { make in
        make.top.equalToSuperview().offset(8)
        make.centerX.equalToSuperview()
    }
    
    rectangleView.snp.makeConstraints { make in
      make.bottom.equalTo(usernameContainerView.snp.top).offset(-8.adjustedH)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(self.viewLevel.rectangleHeight)
    }

    usernameContainerView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview()
      make.height.equalTo(34.f)
      make.width.lessThanOrEqualToSuperview()
    }
  }
}

extension STChartRectangleView {
  public func signalForClickUserName() -> Driver<Void> {
    return self.usernameContainerView.gesture().mapVoid().asDriver()
  }
  
  public func setData(score: Int, username: String) {
    self.usernameLabel.text = username.isEmpty ? "-" : username
    self.usernameLabel.setTypography(Typography.label3, textColor: pointColor)
    self.scoreView.setScore("\(score)")
  }
}

extension STChartRectangleView {
  static func == (left: STChartRectangleView, right: STChartRectangleView) -> Bool {
    return left.viewLevel == right.viewLevel
  }
}
