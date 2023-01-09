//
//  ChartRectangleView.swift
//  DSKit
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core

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

public class ChartRectangleView: UIView {
    
    // MARK: - Properties
    
    public var viewLevel = RectangleViewRank.rankOne
    
    // MARK: - UI Components
    
    private let starRankView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = DSKitAsset.Assets.icStar.image.withRenderingMode(.alwaysTemplate)
        iv.tintColor = DSKitAsset.Colors.purple100.color
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
        label.setTypoStyle(.number2)
        label.partFontChange(targetString: "점", font: DSKitFontFamily.Pretendard.medium.font(size: 12))
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "뉴비"
        label.setTypoStyle(.h3)
        label.textColor = .black
        label.lineBreakMode = .byTruncatingTail
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
}

// MARK: - Methods

// MARK: - UI & Layouts

extension ChartRectangleView {
    
    private func setUI() {
        switch viewLevel {
        case .rankOne:
            rankLabel.text = "1"
            rankLabel.textColor = DSKitAsset.Colors.purple300.color
            rectangleView.backgroundColor = DSKitAsset.Colors.purple200.color
            setScoreLabel(by: DSKitAsset.Colors.purple300.color)
        case .rankTwo:
            rankLabel.text = "2"
            rankLabel.textColor = DSKitAsset.Colors.pink300.color
            rectangleView.backgroundColor = DSKitAsset.Colors.pink200.color
            setScoreLabel(by: DSKitAsset.Colors.pink300.color)
        case .rankThree:
            rankLabel.text = "3"
            rankLabel.textColor = DSKitAsset.Colors.mint300.color
            rectangleView.backgroundColor = DSKitAsset.Colors.mint200.color
            setScoreLabel(by: DSKitAsset.Colors.mint300.color)
        }
    }
    
    private func setScoreLabel(by color: UIColor) {
        scoreLabel.textColor = color
    }
    
    private func setLayout() {
        
        if case .rankOne = viewLevel {
            self.addSubviews(starRankView, rectangleView, usernameLabel)
            
            starRankView.addSubview(rankLabel)
            
            starRankView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(8.adjustedH)
                make.bottom.equalTo(rectangleView.snp.top).offset(-13.adjusted)
                make.centerX.equalToSuperview()
                make.size.equalTo(50.adjusted)
            }
            
            rankLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().inset(3)
            }
        } else {
            self.addSubviews(rankLabel, rectangleView, usernameLabel)
            
            rankLabel.snp.makeConstraints { make in
                make.bottom.equalTo(rectangleView.snp.top).offset(-8.adjusted)
                make.centerX.equalToSuperview()
            }
        }
        
        rectangleView.addSubview(scoreLabel)
        
        scoreLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8.adjusted)
            make.centerX.equalToSuperview()
        }
        
        rectangleView.snp.makeConstraints { make in
            make.bottom.equalTo(usernameLabel.snp.top).offset(-10.adjustedH)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.viewLevel.rectangleHeight)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
        }
    }
}

extension ChartRectangleView {
    public func setData(score: Int, username: String) {
        self.usernameLabel.text = username
        self.scoreLabel.text = "\(score)점"
        self.scoreLabel.partFontChange(targetString: "점",
                                       font: DSKitFontFamily.Pretendard.medium.font(size: 12))
    }
}

extension ChartRectangleView {
    static func == (left: ChartRectangleView, right: ChartRectangleView) -> Bool {
        return left.viewLevel == right.viewLevel
    }
}
