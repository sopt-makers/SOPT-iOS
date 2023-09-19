//
//  NotificationOptInEntity.swift
//  Network
//
//  Created by Ian on 2023/09/17.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

public struct NotificationOptInEntity: Encodable {
    let allOptIn: Bool?
    let partOptIn: Bool?
    let newsOptIn: Bool?
    
    public init(
        allOptIn: Bool?,
        partOptIn: Bool?,
        newsOptIn: Bool?
    ) {
        self.allOptIn = allOptIn
        self.partOptIn = partOptIn
        self.newsOptIn = newsOptIn
    }
}
