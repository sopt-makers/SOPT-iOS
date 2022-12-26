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
    
    var isCompleted: Bool {
        switch self {
        case .levelOne(let completed):
            return completed
        case .levelTwo(let completed):
            return completed
        case .levelThree(let completed):
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
        }
    }
}

// MARK: - Metrics

extension MissionListCellType {
    
    var stampTop: CGFloat {
        switch self {
        case .levelOne:
            return 47.adjustedH
        case .levelTwo:
            return 40.adjustedH
        case .levelThree:
            return 26.adjustedH
        }
    }
    
    var stampWidth: CGFloat {
        switch self {
        case .levelOne:
            return 135.adjusted
        case .levelTwo:
            return 104.adjusted
        case .levelThree:
            return 135.adjusted
        }
    }
    
    var stampHeight: CGFloat {
        switch self {
        case .levelOne:
            return 81.adjusted
        case .levelTwo:
            return 90.adjusted
        case .levelThree:
            return 104.adjusted
        }
    }
    
    var stampLabelSpacing: CGFloat {
        switch self {
        case .levelOne:
            return 16.adjustedH
        case .levelTwo:
            return 13.adjustedH
        case .levelThree:
            return 12.adjustedH
        }
    }
}

extension MissionListModel {
    func toCellType() -> MissionListCellType {
        switch self.level {
        case 1: return .levelOne(completed: self.isCompleted)
        case 2: return .levelTwo(completed: self.isCompleted)
        default: return .levelThree(completed: self.isCompleted)
        }
    }
    
    func toListDetailSceneType() -> ListDetailSceneType {
        return (self.isCompleted == true) ? .edit : .none
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
    
    private lazy var starView: StarView = {
        let view = StarView(starScale: 15.adjusted, spacing: 10.adjusted, level: cellType.starLevel)
        return view
    }()
    
    private let purposeLabel: UILabel = {
        let label = UILabel()
        label.text = "세미나 끝나고 뒷풀이 2시까지 달리기"
        label.setTypoStyle(.caption1D)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
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
        guard cellType.isCompleted else {
            backgroundImageView.tintColor = DSKitAsset.Colors.gray50.color
            starView.changeStarLevel(level: cellType.starLevel)
            return
        }
        
        switch cellType {
        case .levelOne:
            stampImageView.image = DSKitAsset.Assets.levelOneStamp.image
            backgroundImageView.tintColor = DSKitAsset.Colors.pink100.color
        case .levelTwo:
            stampImageView.image = DSKitAsset.Assets.levelTwoStamp.image
            backgroundImageView.tintColor = DSKitAsset.Colors.purple100.color
        case .levelThree:
            stampImageView.image = DSKitAsset.Assets.levelThreeStamp.image
            backgroundImageView.tintColor = DSKitAsset.Colors.mint100.color
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
            make.height.equalTo(15.adjustedH)
        }
        
        purposeLabel.snp.makeConstraints { make in
            make.top.equalTo(starView.snp.bottom).offset(16.adjustedH)
            make.centerX.equalToSuperview()
            make.width.equalTo(116.adjusted)
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
        }
        
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}

// MARK: - Methods

extension MissionListCVC {
    
    public func setData(model: MissionListModel) {
        self.purposeLabel.text = model.title
        self.model = model
    }
}
