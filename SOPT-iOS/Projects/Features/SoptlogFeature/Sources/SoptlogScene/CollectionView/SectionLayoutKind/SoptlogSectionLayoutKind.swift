//
//  SoptlogSectionLayoutKind.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

enum SoptlogSectionLayoutKind: Int, CaseIterable {
    case logo = 0
    case soptampLog
    case pokeLog
//    case banner

    var title: String {
        switch self {
        case .soptampLog: return I18N.Soptlog.soptamp
        case .pokeLog: return I18N.Soptlog.poke
        default: return ""
        }
    }
    
    /// 앱잼 참여 상태에 따라 표시할 섹션 목록
    static func visibleSections(
        isAppjamParticipant: Bool,
        isActiveUser: Bool
    ) -> [SoptlogSectionLayoutKind] {
        var sections: [SoptlogSectionLayoutKind] = [.logo]
        
        if isActiveUser || isAppjamParticipant {
            sections.append(.soptampLog)
        }
        sections.append(.pokeLog)
//        sections.append(.banner)
        
        return sections
    }
}

struct SoptlogCellTapInfo {
    let section: SoptlogSectionLayoutKind
    let row: Int
}
