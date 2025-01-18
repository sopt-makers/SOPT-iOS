//
//  HomeCoffeeChatPostsTransform.swift
//  Data
//
//  Created by Jae Hyun Lee on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension HomeCoffeeChatEntity {
    public func toDomain() -> HomeCoffeeChatPostModel {
        return HomeCoffeeChatPostModel(memberId: memberId, bio: bio, topicTypeList: topicTypeList, profileImage: profileImage, name: name, career: career, organization: organization, companyJob: companyJob, soptActivities: soptActivities, currentSoptActivity: currentSoptActivity)
    }
}
