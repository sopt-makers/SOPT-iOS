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

enum SoptampChartStyle: Int {
    case rankOne = 1
    case rankTwo = 2
    case rankThree = 3
    case otherRank
    
    init(rank: Int) {
        self = SoptampChartStyle(rawValue: rank) ?? .otherRank
    }
    
    var labelColor: UIColor? {
        switch self {
        case .rankOne: SemanticColor.Fg.Neutral.bold
        case .rankTwo: DSKitAsset.Colors.green300.color
        case .rankThree: DSKitAsset.Colors.soptampPurple300.color
        case .otherRank: nil
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .rankOne: DSKitAsset.Colors.soptampPink300.color
        case .rankTwo: DSKitAsset.Colors.green300.color
        case .rankThree: DSKitAsset.Colors.soptampPurple300.color
        case .otherRank: SemanticColor.Bg.Neutral.default
        }
    }
    
    var isLabelHidden: Bool {
        switch self {
        case .rankOne, .rankTwo, .rankThree: false
        case .otherRank: true
        }
    }
    
    var starImage: UIImage? {
        self == .rankOne ? DSKitAsset.Assets.icBigStar.image.withRenderingMode(.alwaysTemplate) : nil
    }
}

public class STPartChartRectangleView: UIView {
    
    // MARK: - Properties
    
    public var rank: Int = 6
    public var partName: String = "파트"
    
    // MARK: - UI Components
    
    private let starRankView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = DSKitAsset.Assets.icBigStar.image.withRenderingMode(.alwaysTemplate)
        $0.tintColor = DSKitAsset.Colors.soptampPink300.color
    }
    
    private let rankLabel: UILabel = UILabel()
    
    private let rectangleView = UIView().then {
        $0.layer.cornerRadius = BaseRadius.Base.r8
    }
    
    private let partNameLabel = UILabel().then {
        $0.lineBreakMode = .byTruncatingTail
    }
    
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
        partNameLabel.setTypography(Typography.label3, textColor: SemanticColor.Fg.Neutral.default)
        
        let style = SoptampChartStyle(rank: rank)
        
        starRankView.isHidden = (rank > 3)
        starRankView.image = style.starImage
        
        rankLabel.isHidden = style.isLabelHidden
        rankLabel.text = style.isLabelHidden ? "" : "\(rank)"
        rankLabel.setTypography(Typography.heading2, textColor: style.labelColor)
        rectangleView.backgroundColor = style.backgroundColor
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

