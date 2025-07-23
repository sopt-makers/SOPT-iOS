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
import DSKit

struct HomePresentationModel {

    let dashBoard: HomePresentationModel.DashBoard
    let recentSchedule: HomePresentationModel.RecentSchedule
    let appServices: [HomePresentationModel.AppService]
    let popularPosts: [HomePresentationModel.PopularPost]
    let recentPosts: [HomePresentationModel.RecentPost]
    let survey: HomePresentationModel.Survey
    
    // MARK: - Item Structs
    
    struct DashBoard: Identifiable, Hashable {
        let id = "dashboard"
        
        let description: NSAttributedString
        let history: [Int]?
        let isAllConfirm: Bool?
        
        init(
            description: NSAttributedString = NSAttributedString(string: ""),
            history: [Int]? = nil,
            isAllConfirm: Bool? = nil
        ) {
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
    }
    
    struct ProductService: Identifiable, Hashable {
        let id = UUID()
        
        let product: ServiceType
    }
    
    struct AppService: Identifiable, Hashable {
        var id: String
        let serviceName: String
        let displayAlarmBadge: Bool
        let alarmBadge, iconURL, deepLink: String
    }
    
    struct PopularPost: Identifiable, Hashable {
        let profileImage: String?
        let name: String
        let generationAndPart: String
        let rank: Int
        let category: String
        let title: String
        let content: String
        let webLink: String
        let id: Int

        init(
            profileImage: String?,
            name: String,
            generationAndPart: String,
            rank: Int,
            category: String,
            title: String,
            content: String,
            webLink: String,
            id: Int
        ) {
            self.profileImage = profileImage
            self.name = name
            self.generationAndPart = generationAndPart
            self.rank = rank
            self.category = category
            self.title = title
            self.content = content
            self.webLink = webLink
            self.id = id
        }
    }

    struct RecentPost: Identifiable, Hashable {
        let profileImage: String?
        let name: String
        let generationAndPart: String
        let category: String
        let title: String
        let content: String
        let webLink: String
        let id: Int
        let isOutdated: Bool

        init(
            profileImage: String?,
            name: String,
            generationAndPart: String,
            category: String,
            title: String,
            content: String,
            webLink: String,
            id: Int,
            isOutdated: Bool
        ) {
            self.profileImage = profileImage
            self.name = name
            self.generationAndPart = generationAndPart
            self.category = category
            self.title = title
            self.content = content
            self.webLink = webLink
            self.id = id
            self.isOutdated = isOutdated
        }
    }
    
    struct Survey: Identifiable, Hashable {
        let id = UUID()
        
        let title: String
        let subTitle: String
        let actionButtonName: String
        let linkURL: String
        let isActive: Bool
    }
    
    struct SocialLink: Identifiable, Hashable {
        let id = UUID()
        
        let socialLink: ServiceType
    }
}

extension HomePresentationModel.PopularPost: PostDisplayable {}
extension HomePresentationModel.RecentPost: PostDisplayable {}

// MARK: - toPresentation

extension HomeDescriptionModel {
    func toPresentation(history: [Int], isAllConfirm: Bool?) -> HomePresentationModel.DashBoard {
        let attrString = NSAttributedString
            .fromHTML(
                description,
                defaultFont: DSKitFontFamily.Suit.medium.font(size: 18),
                boldFont: DSKitFontFamily.Suit.bold.font(size: 18),
                defaultColor: DSKitAsset.Colors.white.color
            )
        return HomePresentationModel.DashBoard(
            description: attrString,
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
            id: self.deepLink,
            serviceName: self.serviceName,
            displayAlarmBadge: self.displayAlarmBadge,
            alarmBadge: self.alarmBadge,
            iconURL: self.iconURL,
            deepLink: self.deepLink
        )
    }
}

extension HomePopularPostModel {
    func toPresentation() -> HomePresentationModel.PopularPost {
        return HomePresentationModel.PopularPost(
            profileImage: self.profileImage,
            name: self.name,
            generationAndPart: self.generationAndPart,
            rank: self.rank,
            category: self.category,
            title: self.title,
            content: self.content,
            webLink: self.webLink,
            id: self.id
        )
    }
}

extension HomeLatestPostModel {
    func toPresentation() -> HomePresentationModel.RecentPost {
        return HomePresentationModel.RecentPost(
            profileImage: self.profileImage,
            name: self.name,
            generationAndPart: self.generationAndPart,
            category: self.category,
            title: self.title,
            content: self.content,
            webLink: self.webLink,
            id: self.id,
            isOutdated: self.isOutdated
        )
    }
}

extension HomeSurveyModel {
    func toPresentation() -> HomePresentationModel.Survey {
        return HomePresentationModel.Survey(
            title: self.title,
            subTitle: self.subTitle,
            actionButtonName: self.actionButtonName,
            linkURL: self.linkURL,
            isActive: self.isActive
        )
    }
}
