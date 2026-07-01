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
    case popularPosts
    case latestPosts
    case survey
    case socialLinks
}

extension HomeForMemberSectionLayoutKind: HomeSectionUIConfigurable {
    var headerTitle: String {
        switch self {
        case .mainProduct:
            return I18N.Home.MainProduct.soptPlayground
        case .popularPosts:
            return I18N.Home.PopularPosts.headerTitle
        case .latestPosts:
            return I18N.Home.LatestPosts.headerTitle
        case .appService:
            return I18N.Home.AppService.headerTitle
        default:
            return ""
        }
    }

    var shouldShowFireIcon: Bool {
        return self == .popularPosts
    }

    var shouldShowViewAllContentButton: Bool {
        return self == .popularPosts || self == .latestPosts
    }

    var isSubSectionHeader: Bool {
        return self == .mainProduct
    }
}
