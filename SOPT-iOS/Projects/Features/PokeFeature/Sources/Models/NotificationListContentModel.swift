//
//  NotificationListContentModel.swift
//  PokeFeature
//
//  Created by Ian on 12/3/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

public struct NotificationListContentModel {
    let userId: Int
    let avatarUrl: String
    let pokeRelation: PokeRelation
    let name: String
    let partInfomation: String
    let description: String
    let chipInfo: PokeChipView.ChipType
    let isPoked: Bool
    let isFirstMeet: Bool
}
