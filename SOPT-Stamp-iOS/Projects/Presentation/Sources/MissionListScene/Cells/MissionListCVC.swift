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

// MARK: MissionListCVC

final class MissionListCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    private var cellType: MissionListCellType = .levelOne(completed: false)
    
    // MARK: - UI Components
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = DSKitAsset.Assets.missionBackground.image.withRenderingMode(.alwaysTemplate)
        iv.clipsToBounds = true
        return iv
    }()
    
    private let stampImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let starView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let purposeLabel: UILabel = {
        let label = UILabel()
        label.text = "세미나 끝나고 2시까지 달리기"
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // MARK: - View Life Cycles
    
    convenience init(_ type: MissionListCellType) {
        self.init()
        self.cellType = type
    }
    
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

extension MissionListCVC {
    
    private func setUI() {
        guard cellType.isCompleted else { return }
        
        switch cellType {
        case .levelOne:
            backgroundImageView.tintColor = DSKitAsset.Colors.pink100.color
        case .levelTwo:
            backgroundImageView.tintColor = DSKitAsset.Colors.purple100.color
        case .levelThree:
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
            make.top.equalTo(starView.snp.bottom).inset(16.adjustedH)
            make.centerX.equalToSuperview()
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
            make.top.equalTo(stampImageView.snp.bottom).inset(cellType.stampLabelSpacing)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension MissionListCVC {
    
    public func setData(model: String) {
        
    }
}

