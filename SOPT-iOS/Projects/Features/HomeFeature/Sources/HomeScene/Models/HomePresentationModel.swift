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
    let latestPosts: [HomePresentationModel.LatestPost]
    let survey: HomePresentationModel.Survey
    
    // MARK: - Item Structs
    
    struct DashBoard: Identifiable, Hashable {
        let id = "dashboard"
        
        let description: NSAttributedString
        let history: [Int]?
        let isAllConfirm: Bool?
        let profileImageURL: String?
        
        init(
            description: NSAttributedString = NSAttributedString(string: ""),
            history: [Int]? = nil,
            isAllConfirm: Bool? = nil,
            profileImageURL: String? = nil
        ) {
            self.description = description
            self.history = history
            self.isAllConfirm = isAllConfirm
            self.profileImageURL = profileImageURL
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
        var type: AppServiceType {
            AppServiceType(rawValue: serviceName) ?? .soptletter
        }
    }
    
    struct PopularPost: Identifiable, Hashable {
        let profileImage: String?
        let name: String?
        let generationAndPart: String?
        let rank: Int
        let category: String
        let title: String
        let content: String
        let webLink: String
        let id: String
        let serverID: Int?
        let userID: Int?
        let ranking: Int?
        let postID: Int?
    }
    
    struct LatestPost: Identifiable, Hashable {
        let id: String
        let profileImage: String?
        let name: String?
        let generationAndPart: String?
        let category: String
        let title: String
        let content: String
        let webLink: String
        let isOutdated: Bool
        let serverID: Int?
        let userID: Int?
        let ranking: Int?
        let postID: Int?
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
extension HomePresentationModel.LatestPost: PostDisplayable {}

// MARK: - toPresentation

extension HomeDescriptionModel {
    func toPresentation(history: [Int], isAllConfirm: Bool?, profileImageURL: String?) -> HomePresentationModel.DashBoard {
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
            isAllConfirm: isAllConfirm,
            profileImageURL: profileImageURL
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
            iconURL: self.iconURL ?? "",
            deepLink: self.deepLink
        )
    }
}

extension HomePopularPostModel {
    // NOTE: 서버에서 post의 id값이 옵셔널로 내려오는 경우가 있어, 필드값을 조합해 ID로 반환합니다.
    var stableID: String {
        if let id = self.id { return "popular:id:\(id)" } // id값이 있다면, 그대로 사용
        // 없다면, 카테고리와 타이틀 값을 조합해서 활용합니다.
        return "popular:category:\(self.category)title:\(self.title)"
    }
    
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
            id: self.stableID,
            serverID: self.id,
            userID: self.userId,
            ranking: self.rank,
            postID: self.id
        )
    }
}

extension HomeLatestPostModel {
    // NOTE: 서버에서 post의 id값이 옵셔널로 내려오는 경우가 있어, 필드값을 조합해 ID로 반환합니다.
    var stableID: String {
        if let id = self.id { return "latest:id:\(id)" } // id값이 있다면, 그대로 사용
        // 없다면, 카테고리와 타이틀 값을 조합해서 활용합니다.
        return "latest:category:\(self.category)title:\(self.title)"
    }
    
    func toPresentation() -> HomePresentationModel.LatestPost {
        return HomePresentationModel.LatestPost(
            id: self.stableID,
            profileImage: self.profileImage,
            name: self.name,
            generationAndPart: self.generationAndPart,
            category: self.category,
            title: self.title,
            content: self.content,
            webLink: self.webLink,
            isOutdated: self.isOutdated,
            serverID: self.id,
            userID: self.userId,
            ranking: 0, // NOTE: 최신글의 경우 0
            postID: self.id
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
