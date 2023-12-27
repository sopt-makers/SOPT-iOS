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
    let chipInfo: String
    let isPoked: Bool
    let isFirstMeet: Bool
}

extension NotificationListContentModel {
    public init() {
        self.userId = 0
        self.avatarUrl = ""
        self.name = "다혜다해"
        self.pokeRelation = .newFriend
        self.partInfomation = "29기 안드로이드"
        self.description = "Text(아는 사람이 없나요?\n화면을 밑으로 당기면 다른 친구를 볼 수 있어요)"
        self.chipInfo = "친한친구"
        self.isPoked = Int.random(in: 0...1) == 0 ? false : true
        self.isFirstMeet = false
    }
}
