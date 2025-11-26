//
//  SoptlogSectionModel.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

struct SoptlogMenuModel {
    let title: String
    let value: String
    let hasTooltip: Bool
    let hasChevron: Bool
}

struct SoptlogSectionModel {
    static let soptamp: [SoptlogMenuModel] = [
        SoptlogMenuModel(title: I18N.Soptlog.Menu.completedMission, value: "999회", hasTooltip: false, hasChevron: true),
        SoptlogMenuModel(title: I18N.Soptlog.Menu.views, value: "999회", hasTooltip: true, hasChevron: false),
        SoptlogMenuModel(title: I18N.Soptlog.Menu.receivedClapCount, value: "999회", hasTooltip: false, hasChevron: false),
        SoptlogMenuModel(title: I18N.Soptlog.Menu.clapCount, value: "999회", hasTooltip: false, hasChevron: false)
    ]
    
    static let poke: [SoptlogMenuModel] = [
        SoptlogMenuModel(title: I18N.Soptlog.Menu.pokeCount, value: "999회", hasTooltip: false, hasChevron: true),
        SoptlogMenuModel(title: I18N.Soptlog.Menu.newFriend, value: "999회", hasTooltip: false, hasChevron: true),
        SoptlogMenuModel(title: I18N.Soptlog.Menu.bestFriend, value: "999회", hasTooltip: false, hasChevron: true),
        SoptlogMenuModel(title: I18N.Soptlog.Menu.soulmate, value: "999회", hasTooltip: false, hasChevron: true)
    ]
}

