//
//  NotificationOptInModel.swift
//  Domain
//
//  Created by Ian on 2023/09/19.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

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
