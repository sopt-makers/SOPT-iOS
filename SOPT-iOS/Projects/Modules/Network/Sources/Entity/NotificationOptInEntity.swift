//
//  DetailNotificationOptInEntity.swift
//  Network
//
//  Created by Ian on 2023/09/17.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

public struct DetailNotificationOptInEntity: Codable {
    public let allOptIn: Bool?
    public let partOptIn: Bool?
    public let newsOptIn: Bool?
    
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
