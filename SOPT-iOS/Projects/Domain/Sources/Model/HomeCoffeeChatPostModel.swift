//
//  HomeCoffeeChatPostModel.swift
//  Domain
//
//  Created by Jae Hyun Lee on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct HomeCoffeeChatPostModel: Codable {
    public let memberId: Int
    public let bio: String
    public let topicTypeList: [String]
    public let profileImage: String
    public let name: String
    public let career: String?
    public let organization: String
    public let companyJob: String?
    public let soptActivities: [String]
    public let currentSoptActivity: String?
    
    public init(memberId: Int, bio: String, topicTypeList: [String], profileImage: String, name: String, career: String?, organization: String, companyJob: String?, soptActivities: [String], currentSoptActivity: String?) {
        self.memberId = memberId
        self.bio = bio
        self.topicTypeList = topicTypeList
        self.profileImage = profileImage
        self.name = name
        self.career = career
        self.organization = organization
        self.companyJob = companyJob
        self.soptActivities = soptActivities
        self.currentSoptActivity = currentSoptActivity
    }
}
