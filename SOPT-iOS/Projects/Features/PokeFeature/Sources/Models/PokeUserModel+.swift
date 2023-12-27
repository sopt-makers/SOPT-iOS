//
//  PokeUserModel+.swift
//  PokeFeature
//
//  Created by sejin on 12/23/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Domain

extension PokeUserModel {
    func makeChipInfo() -> PokeChipView.ChipType {
        let model = self
        if model.isFirstMeet { // 친구가 아닌 경우
            switch model.mutual.count {
            case 0:
                return .newUser
            case 1:
                return .singleFriend(friendName: model.mutual.first ?? "")
            default:
                return .acquaintance(friendname: model.mutual.first ?? "", relationCount: "\(model.mutual.count-1)명")
            }
        }
        
        return .withPokeCount(relation: model.relationName, pokeCount: String(model.pokeNum))
    }
}
