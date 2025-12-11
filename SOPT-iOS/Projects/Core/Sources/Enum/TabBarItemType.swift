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
    case soptstamp
    case soptlog
}

public extension TabBarItemType {
    var toAmplitudeEventType: AmplitudeEventType {
        switch self {
        case .home: return .clickNaviHome
        case .soptstamp: return .clickNaviSoptamp
        case .soptlog: return .clickNaviSoptlog
        case .poke: return .clickNaviPoke
        }
    }
}
