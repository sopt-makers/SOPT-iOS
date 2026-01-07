//
//  SoptlogPresentationModel.swift
//  SoptlogFeatureTests
//
//  Created by 강윤서 on 1/20/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core
import Domain

struct SoptlogPresentationModel {
    let isAppjamParticipant: Bool
    let soptampMenus: [SoptlogMenuModel]
    let pokeMenus: [SoptlogMenuModel]
    let alarm: Alarm

    struct Alarm {
        let isFortuneChecked: Bool
        let todayFortuneText: String
    }
}

extension SoptlogModel {
    func toPresentation() -> SoptlogPresentationModel {
        let soptampMenus: [SoptlogMenuModel] = [
            SoptlogMenuModel(
                title: I18N.Soptlog.Menu.completedMission,
                value: "\(soptampCount ?? 0)회",
                hasTooltip: false,
                hasChevron: true
            ),
            SoptlogMenuModel(
                title: I18N.Soptlog.Menu.views,
                value: "\(viewCount ?? 0)회",
                hasTooltip: true,
                hasChevron: false
            ),
            SoptlogMenuModel(
                title: I18N.Soptlog.Menu.receivedClapCount,
                value: "\(myClapCount ?? 0)회",
                hasTooltip: false,
                hasChevron: false
            )
        ]

        let pokeMenus: [SoptlogMenuModel] = [
            SoptlogMenuModel(
                title: I18N.Soptlog.Menu.pokeCount,
                value: "\(totalPokeCount)회",
                hasTooltip: false,
                hasChevron: true
            ),
            SoptlogMenuModel(
                title: I18N.Soptlog.Menu.newFriend,
                value: "\(newFriendsPokeCount)회",
                hasTooltip: false,
                hasChevron: true
            ),
            SoptlogMenuModel(
                title: I18N.Soptlog.Menu.bestFriend,
                value: "\(bestFriendsPokeCount)회",
                hasTooltip: false,
                hasChevron: true
            ),
            SoptlogMenuModel(
                title: I18N.Soptlog.Menu.soulmate,
                value: "\(soulmatesPokeCount)회",
                hasTooltip: false,
                hasChevron: true
            )
        ]

        return SoptlogPresentationModel(
            isAppjamParticipant: isAppjamParticipant,
            soptampMenus: soptampMenus,
            pokeMenus: pokeMenus,
            alarm: SoptlogPresentationModel.Alarm(
                isFortuneChecked: isFortuneChecked,
                todayFortuneText: todayFortuneText
            )
        )
    }
}
