//
//  HomePresentationModel.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 2/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain

struct HomePresentationModel {

    let dashBoard: HomePresentationModel.DashBoard
    let recentSchedule: HomePresentationModel.RecentSchedule
    let appServices: [HomePresentationModel.AppService]
    
    // TODO: 이후 스프린트에서 순차 배포
//    let insightPosts: [HomePresentationModel.InsightPost]
//    let groupPosts: [HomePresentationModel.GroupPost]
//    let coffeeChatPosts: [HomePresentationModel.CoffeeChat]
//    let announcementPosts: [HomePresentationModel.Announcement]

    // MARK: - Item Structs
    
    struct DashBoard: Identifiable, Hashable {
        let id = "dashboard"
        
        let description: String?
        let history: [Int]?
        let isAllConfirm: Bool?
        
        init(description: String? = nil, history: [Int]? = nil, isAllConfirm: Bool? = nil) {
            self.description = description
            self.history = history
            self.isAllConfirm = isAllConfirm
        }
    }
    
    struct RecentSchedule: Identifiable, Hashable {
        let id = UUID()
        
        let date: String
        let type: String
        let title: String
        
        init(date: String, type: String, title: String) {
            self.date = date
            self.type = type
            self.title = title
        }
    }
    
    struct ProductService: Identifiable, Hashable {
        let id = UUID()
        
        let product: ServiceType
        
        init(product: ServiceType) {
            self.product = product
        }
    }
    
    struct AppService: Identifiable, Hashable {
        var id: String
        let serviceName: String
        let displayAlarmBadge: Bool
        let alarmBadge, iconURL, deepLink: String
        
        init(
            serviceName: String,
            displayAlarmBadge: Bool,
            alarmBadge: String,
            iconURL: String,
            deepLink: String
        ) {
            self.serviceName = serviceName
            self.displayAlarmBadge = displayAlarmBadge
            self.alarmBadge = alarmBadge
            self.iconURL = iconURL
            self.deepLink = deepLink
            self.id = deepLink
        }
    }
    
    struct InsightPost: Identifiable, Hashable {
        let id = UUID()

        let title, category: String
        let profileImage: String?
        let name: String?
        let content: String
        let isHotPost: Bool
        
        init(
            title: String,
            category: String,
            profileImage: String? = nil,
            name: String? = nil,
            content: String,
            isHotPost: Bool
        ) {
            self.title = title
            self.category = category
            self.profileImage = profileImage
            self.name = name
            self.content = content
            self.isHotPost = isHotPost
        }
    }
    
    struct GroupPost: Identifiable, Hashable {
        let id: Int
        let title: String
        let category: HomeGroupPostModel.Category
        let canJoinOnlyActiveGeneration: Bool
        let joinableParts: [String]
        let canJoinAllParts: Bool
        let status: HomeGroupPostModel.Status
        let imageUrl: String
        
        init(
            id: Int,
            title: String,
            category: HomeGroupPostModel.Category,
            canJoinOnlyActiveGeneration: Bool,
            joinableParts: [String],
            canJoinAllParts: Bool,
            status: HomeGroupPostModel.Status,
            imageUrl: String
        ) {
            self.id = id
            self.title = title
            self.category = category
            self.canJoinOnlyActiveGeneration = canJoinOnlyActiveGeneration
            self.joinableParts = joinableParts
            self.canJoinAllParts = canJoinAllParts
            self.status = status
            self.imageUrl = imageUrl
        }
    }
    
    struct CoffeeChat: Identifiable, Hashable {
        let id: Int
        let bio: String
        let topicTypeList: [String]
        let profileImage: String?
        let name: String
        let career: String?
        let organization: String?
        let companyJob: String?
        let soptActivities: [String]
        let currentSoptActivity: String?
        
        init(
            id: Int,
            bio: String,
            topicTypeList: [String],
            profileImage: String? = nil,
            name: String,
            career: String? = nil,
            organization: String? = nil,
            companyJob: String? = nil,
            soptActivities: [String],
            currentSoptActivity: String? = nil
        ) {
            self.id = id
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
    
    struct Announcement: Identifiable, Hashable {
        let id: Int
        let profileImage, name: String?
        let categoryName, title: String
        let content: String
        let images: [String]?
        
        init(
            id: Int,
            profileImage: String? = nil,
            name: String? = nil,
            categoryName: String,
            title: String,
            content: String,
            images: [String]? = nil
        ) {
            self.id = id
            self.profileImage = profileImage
            self.name = name
            self.categoryName = categoryName
            self.title = title
            self.content = content
            self.images = images
        }
    }
}

// MARK: - toPresentation

extension HomeDescriptionModel {
    func toPresentation(history: [Int], isAllConfirm: Bool?) -> HomePresentationModel.DashBoard {
        return HomePresentationModel.DashBoard(
            description: self.description,
            history: history,
            isAllConfirm: isAllConfirm
        )
    }
}

extension HomeRecentScheduleModel {
    func toPresentation() -> HomePresentationModel.RecentSchedule {
        return HomePresentationModel.RecentSchedule(
            date: changeFormat(self.date),
            type: self.type,
            title: self.title
        )
    }
    
    private func changeFormat(_ dateString: String) -> String {
        return dateString.split(separator: "-").joined(separator: ".")
    }
}

extension HomeAppServicesModel {
    func toPresentation() -> HomePresentationModel.AppService {
        return HomePresentationModel.AppService(
            serviceName: self.serviceName,
            displayAlarmBadge: self.displayAlarmBadge,
            alarmBadge: self.alarmBadge,
            iconURL: self.iconURL,
            deepLink: self.deepLink
        )
    }
}

extension HomeInsightPostsModel {
    func toPresentation() -> HomePresentationModel.InsightPost {
        return HomePresentationModel.InsightPost(
            title: self.title,
            category: self.category,
            profileImage: self.profileImage,
            name: self.name,
            content: self.content,
            isHotPost: self.isHotPost
        )
    }
}

extension HomeGroupPostModel {
    func toPresentation() -> HomePresentationModel.GroupPost {
        return HomePresentationModel.GroupPost(
            id: self.id,
            title: self.title,
            category: self.category,
            canJoinOnlyActiveGeneration: self.canJoinOnlyActiveGeneration,
            joinableParts: self.joinableParts,
            canJoinAllParts: self.canJoinAllParts,
            status: self.status,
            imageUrl: self.imageUrl
        )
    }
}

extension HomeCoffeeChatPostModel {
    func toPresentation() -> HomePresentationModel.CoffeeChat {
        return HomePresentationModel.CoffeeChat(
            id: self.memberId,
            bio: self.bio,
            topicTypeList: self.topicTypeList,
            name: self.name,
            soptActivities: self.soptActivities
        )
    }
}

extension HomeAnnouncementModel {
    func toPresentation() -> HomePresentationModel.Announcement {
        return HomePresentationModel.Announcement(
            id: self.id,
            profileImage: self.profileImage,
            name: self.name,
            categoryName: self.categoryName,
            title: self.title,
            content: self.content,
            images: self.images
        )
    }
}
