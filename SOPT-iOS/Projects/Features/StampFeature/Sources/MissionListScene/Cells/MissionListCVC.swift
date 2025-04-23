//
//  MissionListCVC.swift
//  PresentationTests
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain
import DSKit

import SnapKit

// MARK: MissionListCellType

@frozen
enum MissionListCellType {
    case levelOne(completed: Bool)
    case levelTwo(completed: Bool)
    case levelThree(completed: Bool)
    case levelTen(completed: Bool)
    
    var isCompleted: Bool {
        switch self {
        case
            let .levelOne(completed),
            let .levelTwo(completed),
            let .levelThree(completed),
            let .levelTen(completed):
            return completed
        }
    }
    
    var starLevel: StarViewLevel {
        switch self {
        case .levelOne:
            return .levelOne
        case .levelTwo:
            return .levelTwo
        case .levelThree:
            return .levelThree
        case .levelTen:
            return .levelTen
        }
    }
}

// MARK: - Metrics

extension MissionListCellType {
    
    var stampTop: CGFloat {
        switch self {
        case .levelOne:
            return 47
        case .levelTwo:
            return 40
        case .levelThree:
            return 26
        case .levelTen:
            return 36
        }
    }
    
    var stampWidth: CGFloat {
        switch self {
        case .levelOne:
            return 135
        case .levelTwo:
            return 125
        case .levelThree:
            return 104
        case .levelTen:
            return 124
        }
    }
    
    var stampHeight: CGFloat {
        switch self {
        case .levelOne:
            return 81
        case .levelTwo:
            return 90
        case .levelThree:
            return 104
        case .levelTen:
            return 87
        }
    }
    
    var stampLabelSpacing: CGFloat {
        switch self {
        case .levelOne:
            return 16
        case .levelTwo:
            return 13
        case .levelThree:
            return 12
        case .levelTen:
            return 19
        }
    }
}

extension MissionListModel {
    func toCellType() -> MissionListCellType {
        switch self.level {
        case 1: return .levelOne(completed: self.isCompleted)
        case 2: return .levelTwo(completed: self.isCompleted)
        case 3: return .levelThree(completed: self.isCompleted)
        case 10: return .levelTen(completed: self.isCompleted)
        default: return .levelThree(completed: self.isCompleted)
        }
    }
    
    func toListDetailSceneType() -> ListDetailSceneType {
        return (self.isCompleted == true) ? .completed : .none
    }
}

// MARK: MissionListCVC

final class MissionListCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    
    public var model: MissionListModel?
    private var cellType: MissionListCellType = .levelOne(completed: false)
    public var initCellType: MissionListCellType {
        get { return self.cellType }
        set {
            DispatchQueue.main.async {
                self.prepareForReuse()
                self.cellType = newValue
                self.setUI(newValue)
                self.setLayout()
            }
        }
    }
    
    // MARK: - UI Components
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = DSKitAsset.Assets.missionBackground.image.withRenderingMode(.alwaysTemplate)
        iv.clipsToBounds = true
        return iv
    }()
    
    private let stampImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var starView: STStarView = {
        let view = STStarView(starScale: 15.adjusted, spacing: 10.adjusted, level: cellType.starLevel)
        return view
    }()
    
    private let purposeLabel: UILabel = {
        let label = UILabel()
        label.textColor = DSKitAsset.Colors.white.color
        label.setTypoStyle(.SoptampFont.caption1D)
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - View Life Cycles
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
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

extension MissionListCVC {
    
    public func setUI(_ type: MissionListCellType) {
        backgroundImageView.tintColor = DSKitAsset.Colors.gray800.color
        
        guard cellType.isCompleted else {
            starView.changeStarLevel(level: cellType.starLevel)
            return
        }
        
        switch cellType {
        case .levelOne:
            stampImageView.image = DSKitAsset.Assets.levelOneStamp.image
        case .levelTwo:
            stampImageView.image = DSKitAsset.Assets.levelTwoStamp.image
        case .levelThree:
            stampImageView.image = DSKitAsset.Assets.levelThreeStamp.image
        case .levelTen:
            stampImageView.image = DSKitAsset.Assets.levelTenStamp.image
        }
    }
    
    private func setLayout() {
        self.addSubview(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.cellType.isCompleted
        ? self.setCompletedLayout()
        : self.setOnGoingLayout()
    }
    
    private func setOnGoingLayout() {
        self.backgroundImageView.addSubviews(starView, purposeLabel)
        
        starView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(70.adjustedH)
            make.centerX.equalToSuperview()
        }
        
        purposeLabel.snp.makeConstraints { make in
            make.top.equalTo(starView.snp.bottom).offset(16.adjustedH)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(116.adjusted)
        }
    }
    
    private func setCompletedLayout() {
        self.backgroundImageView.addSubviews(stampImageView, purposeLabel)
        
        stampImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(cellType.stampTop)
            make.centerX.equalToSuperview()
            make.width.equalTo(cellType.stampWidth)
            make.height.equalTo(cellType.stampHeight)
        }
        
        purposeLabel.snp.makeConstraints { make in
            make.top.equalTo(stampImageView.snp.bottom).offset(cellType.stampLabelSpacing)
            make.centerX.equalToSuperview()
            make.width.equalTo(116.adjusted)
        }
    }
    
    private func prepareCell() {
        self.backgroundImageView.subviews.forEach {
            $0.removeFromSuperview()
            $0.snp.removeConstraints()
        }
        
        self.subviews.forEach {
            $0.removeFromSuperview()
            $0.snp.removeConstraints()
        }
    }
}

// MARK: - Methods

extension MissionListCVC {
    
    public func setData(model: MissionListModel) {
        self.setAttributedTextForPurpose(text: model.title)
        self.model = model
    }
    
    private func setAttributedTextForPurpose(text: String) {
        let attributedStr = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.2
        style.alignment = .center
        style.lineBreakMode = .byTruncatingTail
        style.lineBreakStrategy = .hangulWordPriority
        attributedStr.addAttribute(NSAttributedString.Key.kern, value: 0, range: NSMakeRange(0, attributedStr.length))
        attributedStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributedStr.length))
        self.purposeLabel.attributedText = attributedStr
    }
}
