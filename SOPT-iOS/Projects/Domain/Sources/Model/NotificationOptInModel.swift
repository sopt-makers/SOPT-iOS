//
//  NotificationOptInModel.swift
//  Domain
//
//  Created by Ian on 2023/09/19.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

// NOTE:(@승호) User에 매핑되어 있는 프로퍼티. 현재 기준 유저에 안 담겨 옴, User의 update 대신 entity를 만들 용도로 사용함.
// 이후 알림의 위계 변경시 위치를 조정할 수 있음. - 2023.09.19 -
// see also: https://github.com/sopt-makers/sopt-backend/blob/7417a4d7c4b3d423da3802575d3c5ea7a3382ef6/src/main/java/org/sopt/app/domain/entity/User.java#L43

public struct NotificationOptInModel {
    public let allOptIn: Bool?
    public let partOptIn: Bool?
    public let newsOptIn: Bool?
    
    public init(
        allOptIn: Bool? = nil,
        partOptIn: Bool? = nil,
        newsOptIn: Bool? = nil
    ) {
        self.allOptIn = allOptIn
        self.partOptIn = partOptIn
        self.newsOptIn = newsOptIn
    }
}
