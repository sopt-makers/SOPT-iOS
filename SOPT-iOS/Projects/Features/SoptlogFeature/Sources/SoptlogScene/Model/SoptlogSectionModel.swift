//
//  SoptlogSectionModel.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

struct SoptlogMenuModel {
    let title: String
    let value: String
    let hasTooltip: Bool
    let hasChevron: Bool
}

struct SoptlogSectionModel {
    static let soptamp: [SoptlogMenuModel] = [
        SoptlogMenuModel(title: "완료 미션", value: "999회", hasTooltip: false, hasChevron: true),
        SoptlogMenuModel(title: "조회수", value: "999회", hasTooltip: true, hasChevron: false),
        SoptlogMenuModel(title: "받은 박수", value: "999회", hasTooltip: false, hasChevron: false),
        SoptlogMenuModel(title: "쳐준 박수", value: "999회", hasTooltip: false, hasChevron: false)
    ]
    
    static let poke: [SoptlogMenuModel] = [
        SoptlogMenuModel(title: "총 콕찌르기", value: "999회", hasTooltip: false, hasChevron: true),
        SoptlogMenuModel(title: "친한 친구", value: "999회", hasTooltip: false, hasChevron: true),
        SoptlogMenuModel(title: "단짝 친구", value: "999회", hasTooltip: false, hasChevron: true),
        SoptlogMenuModel(title: "천생 연분", value: "999회", hasTooltip: false, hasChevron: true)
    ]
}

