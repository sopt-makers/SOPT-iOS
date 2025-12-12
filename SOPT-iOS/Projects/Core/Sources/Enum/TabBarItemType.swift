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
    case poke
    case soptamp
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
    
    func getTabIndex(userType: UserType) -> Int {
        switch userType {
        case .active:
            switch self {
            case .home:
                0
            case .soptamp:
                1
            case .poke:
                2
            case .soptlog:
                3
            }
        case .visitor, .inactive:
            switch self {
            case .home, .soptamp:
                0
            case .poke:
                1
            case .soptlog:
                2
            }
        }
    }
}
