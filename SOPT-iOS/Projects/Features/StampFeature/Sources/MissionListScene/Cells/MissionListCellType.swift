//
//  MissionListCellType.swift
//  StampFeature
//
//  Created by 강윤서 on 6/1/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit

enum MissionListCellType {
    case mission(level: StarViewLevel, completed: Bool)
    
    var isCompleted: Bool {
        switch self {
        case .mission(_, let completed):
            return completed
        }
    }
    
    var starLevel: StarViewLevel {
        switch self {
        case .mission(let level, _):
            return level
        }
    }
    
    var completedImage: UIImage {
        switch self {
        case .mission(let level, _):
            switch level {
            case .levelOne: return DSKitAsset.Assets.levelOneStamp.image
            case .levelTwo: return DSKitAsset.Assets.levelTwoStamp.image
            case .levelThree: return DSKitAsset.Assets.levelThreeStamp.image
            case .levelTen: return DSKitAsset.Assets.levelTenStamp.image
            }
        }
    }
    
    var starColor: UIColor {
        switch self {
        case .mission(let level, _):
            switch level {
            case .levelOne: return DSKitAsset.Colors.soptampPink300.color
            case .levelTwo: return DSKitAsset.Colors.soptampPurple300.color
            case .levelThree: return DSKitAsset.Colors.soptampMint300.color
            case .levelTen: return DSKitAsset.Colors.orange300.color
            }
        }
    }
}

// MARK: - Metrics

extension MissionListCellType {
    var stampTop: CGFloat {
        switch self {
        case .mission(let level, _):
            switch level {
            case .levelOne: return 47
            case .levelTwo: return 40
            case .levelThree: return 26
            case .levelTen: return 36
            }
        }
    }
    
    var stampWidth: CGFloat {
        switch self {
        case .mission(let level, _):
            switch level {
            case .levelOne: return 135
            case .levelTwo: return 125
            case .levelThree: return 104
            case .levelTen: return 124
            }
        }
    }
    
    var stampHeight: CGFloat {
        switch self {
        case .mission(let level, _):
            switch level {
            case .levelOne: return 81
            case .levelTwo: return 90
            case .levelThree: return 104
            case .levelTen: return 87
            }
        }
    }
    
    var stampLabelSpacing: CGFloat {
        switch self {
        case .mission(let level, _):
            switch level {
            case .levelOne: return 16
            case .levelTwo: return 13
            case .levelThree: return 12
            case .levelTen: return 19
            }
        }
    }
}

extension MissionListModel {
    func toCellType() -> MissionListCellType {
        guard let level = StarViewLevel(rawValue: self.level) else {
            return .mission(level: .levelThree, completed: self.isCompleted)
        }
        return .mission(level: level, completed: self.isCompleted)
    }
    
    func toListDetailSceneType() -> ListDetailSceneType {
        return (self.isCompleted == true) ? .completed : .none
    }
}
