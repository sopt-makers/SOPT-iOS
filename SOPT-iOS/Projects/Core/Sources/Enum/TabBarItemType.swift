//
//  TabBarItemType.swift
//  Core
//
//  Created by 강윤서 on 3/25/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public enum TabBarItemType: CaseIterable {
    case home
    case soptamp
    case poke
    case mypage
}

public extension TabBarItemType {
    var toAmplitudeEventType: AmplitudeEventType {
        switch self {
        case .home: return .clickNaviHome
        case .soptamp: return .clickNaviSoptamp
        case .mypage: return .clickNaviMyPage
        case .poke: return .clickNaviPoke        
        }
    }

    /// 실제로 탭바에 노출 중인 탭 구성(tab-app-service 응답에 따라 동적으로 달라짐) 내에서의 인덱스
    func getTabIndex(in activeTabTypes: [TabBarItemType]) -> Int? {
        activeTabTypes.firstIndex(of: self)
    }

    /// 실제 탭바 인덱스 -> TabBarItemType (활성화된 탭 구성 기준)
    static func from(index: Int, in activeTabTypes: [TabBarItemType]) -> TabBarItemType? {
        guard activeTabTypes.indices.contains(index) else { return nil }
        return activeTabTypes[index]
    }

    /// tab-app-service 응답의 serviceName -> TabBarItemType 매핑
    static func from(tabAppServiceName serviceName: String) -> TabBarItemType? {
        switch serviceName {
        case "솝탬프": return .soptamp
        case "콕찌르기": return .poke
        default: return nil
        }
    }
}
