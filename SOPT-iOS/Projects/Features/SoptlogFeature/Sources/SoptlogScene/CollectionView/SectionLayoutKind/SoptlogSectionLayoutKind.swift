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
    case banner

    var title: String {
        switch self {
        case .soptampLog: return I18N.Soptlog.soptamp
        case .pokeLog: return I18N.Soptlog.poke
        default: return ""
        }
    }

    func numberOfItems(isPokeEmpty: Bool) -> Int {
        switch self {
        case .logo: return 1
        case .soptampLog: return SoptlogSectionModel.soptamp.count
        case .pokeLog: return isPokeEmpty ? 1 : SoptlogSectionModel.poke.count
        case .banner: return 1
        }
    }
}
