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
            #warning("TODO: - 엠플리튜드 연결")
        case .soptamp: return .clickNaviHome
        case .soptlog: return .clickNaviSoptlog
        case .poke: return .clickNaviHome
        }
    }
    
    func getTabIndex(userType: UserType, index: Int) -> Int {
        switch userType {
        case .active:
            return self.rawValue
        case .visitor, .inactive:
            switch self {
            case .home, .soptamp:
                return 0
            case .poke:
                return 1
            case .soptlog:
                return 2
            }
        }
    }
}
