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
    let playgroundNewsPosts: [HomePresentationModel.PlaygroundNews]
//    let recentPosts: [HomePresentationModel.RecentPost]     // TODO: @재현 - 서버 통신 시 해제
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
    
    struct PlaygroundNews: Identifiable, Hashable {
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

    // TODO: @재현 - 서버 통신 시 모델 변경
    struct RecentPost: Identifiable, Hashable {
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
    
    struct Survey: Identifiable, Hashable {
        let id = UUID()
        
        let title: String
        let subTitle: String
        let actionButtonName: String
        let linkURL: String
        let isActive: Bool
        
        init(
            title: String,
            subTitle: String,
            actionButtonName: String,
            linkURL: String,
            isActive: Bool
        ) {
            self.title = title
            self.subTitle = subTitle
            self.actionButtonName = actionButtonName
            self.linkURL = linkURL
            self.isActive = isActive
        }
    }
    
    struct SocialLink: Identifiable, Hashable {
        let id = UUID()
        
        let socialLink: ServiceType
        
        init(socialLink: ServiceType) {
            self.socialLink = socialLink
        }
    }
}

extension HomePresentationModel.PlaygroundNews: PostDisplayable {}
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
            serviceName: self.serviceName,
            displayAlarmBadge: self.displayAlarmBadge,
            alarmBadge: self.alarmBadge,
            iconURL: self.iconURL,
            deepLink: self.deepLink
        )
    }
}

extension HomePlaygroundNewsPostsModel {
    func toPresentation() -> HomePresentationModel.PlaygroundNews {
        return HomePresentationModel.PlaygroundNews(
            title: self.title,
            category: self.category,
            profileImage: self.profileImage,
            name: self.name,
            content: self.content,
            isHotPost: self.isHotPost
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
