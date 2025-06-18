//
//  HomeForMemberSectionLayoutKind.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

enum HomeForMemberSectionLayoutKind: Int, CaseIterable {
    case dashBoard
    case calendar
    case mainProduct
    case appService
    case playgroundNews
    case recentPost
    case survey
    case socialLinks
}

extension HomeForMemberSectionLayoutKind: HomeSectionUIConfigurable {
    var headerTitle: String {
        switch self {
        case .appService:
            return I18N.Home.AppService.headerTitle
        case .playgroundNews:
            return I18N.Home.PlaygroundNews.headerTitle
        case .recentPost:
            return I18N.Home.RecentPost.headerTitle
        default:
            return ""
        }
    }
    
    var shouldShowFireIcon: Bool {
        return self == .playgroundNews
    }
    
    var shouldShowViewAllButton: Bool {
        return self == .recentPost
    }
}
