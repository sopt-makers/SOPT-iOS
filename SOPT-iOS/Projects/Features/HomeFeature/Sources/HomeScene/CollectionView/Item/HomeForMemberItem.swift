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
}
