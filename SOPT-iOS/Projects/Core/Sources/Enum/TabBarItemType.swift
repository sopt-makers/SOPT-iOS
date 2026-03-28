//
//  TabBarItemType.swift
//  Core
//
//  Created by 강윤서 on 3/25/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public enum TabBarItemType: Int, CaseIterable {
    case home
    case soptamp
    case poke
    case soptlog
}

public extension TabBarItemType {
    var toAmplitudeEventType: AmplitudeEventType {
        switch self {
        case .home: return .clickNaviHome
        case .soptamp: return .clickNaviSoptamp
        case .soptlog: return .clickNaviSoptlog
        case .poke: return .clickNaviPoke
        }
    }
    
    /// 유저타입 별 탭 바 인덱스 매핑
    func getTabIndex(userType: UserType) -> Int {
        switch userType {
        case .active, .inactive:
            switch self {
            case .home:
                return 0
            case .soptamp:
                return 1
            case .poke:
                return 2
            case .soptlog:
                return 3
            }
        case .visitor:
            switch self {
            case .home, .soptamp:
                return 0
            case .poke:
                return 1
            case .soptlog:
                return 1
            }
        }
    }
    
    /// 실제 탭바 인덱스 -> TabBarItemType
    static func from(index: Int, userType: UserType) -> TabBarItemType? {
        switch userType {
        case .active, .inactive:
            switch index {
            case 0: return .home
            case 1: return .soptamp
            case 2: return .poke
            case 3: return .soptlog
            default: return nil
            }
        case .visitor:
            switch index {
            case 0: return .home
            case 1: return .soptlog
            default: return nil
            }
        }
    }
}
