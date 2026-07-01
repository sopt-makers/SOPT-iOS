//
//  AppJamStampResponseEntity.swift
//  Networks
//
//  Created by a on 6/17/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

public struct AppJamStampResponseEntity: Codable {
    public let id: Int
    public let contents: String
    public let images: [String]
    public let activityDate: String
    public let createdAt: String
    public let updatedAt: String
    public let missionId: Int
    public let clapCount: Int
    public let viewCount: Int
    
    public init(
        id: Int,
        contents: String,
        images: [String],
        activityDate: String,
        createdAt: String,
        updatedAt: String,
        missionId: Int,
        clapCount: Int,
        viewCount: Int
    ) {
        self.id = id
        self.contents = contents
        self.images = images
        self.activityDate = activityDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.missionId = missionId
        self.clapCount = clapCount
        self.viewCount = viewCount
    }
}
