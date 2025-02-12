//
//  HomeForMemberItem.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 2/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

enum HomeForMemberItem: Hashable {
    case description(HomePresentationModel.Description)
    case recentSchedule(HomePresentationModel.RecentSchedule)
    case productService(HomePresentationModel.ProductService)
    case appService(HomePresentationModel.AppService)
    case insightPost(HomePresentationModel.InsightPost)
    case groupPost(HomePresentationModel.GroupPost)
    case coffeeChat(HomePresentationModel.CoffeeChat)
    case announcement(HomePresentationModel.Announcement)
    case socialLink(SocialLinkCardType)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .description(let model):
            hasher.combine(model.id.hashValue)
        case .recentSchedule(let model):
            hasher.combine(model.id.hashValue)
        case .productService(let model):
            hasher.combine(model.id.hashValue)
        case .appService(let model):
            hasher.combine(model.id.hashValue)
        case .insightPost(let model):
            hasher.combine(model.id.hashValue)
        case .groupPost(let model):
            hasher.combine(model.id.hashValue)
        case .coffeeChat(let model):
            hasher.combine(model.id.hashValue)
        case .announcement(let model):
            hasher.combine(model.id.hashValue)
        case .socialLink(let model):
            hasher.combine(model.hashValue)
        }
    }
}
