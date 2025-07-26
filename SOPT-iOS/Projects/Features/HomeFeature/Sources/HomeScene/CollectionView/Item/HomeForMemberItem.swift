//
//  HomeForMemberItem.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 2/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

enum HomeForMemberItem: Hashable {
    case dashBoard(HomePresentationModel.DashBoard)
    case recentSchedule(HomePresentationModel.RecentSchedule)
    case productService(HomePresentationModel.ProductService)
    case appService(HomePresentationModel.AppService)
    case popularPost(HomePresentationModel.PopularPost)
    case latestPost(HomePresentationModel.LatestPost) 
    case survey(HomePresentationModel.Survey)
    case socialLink(HomePresentationModel.SocialLink)
}
