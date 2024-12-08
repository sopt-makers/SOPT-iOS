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
    case mainProduct
    case appService
    case insight
    case group
    case coffeeChat
    case announcement
    case socialLinks
    
    var title: String {
        switch self {
        case .appService:
            return I18N.Home.AppService.headerTitle
        case .insight:
            return I18N.Home.Insight.headerTitle
        case .group:
            return I18N.Home.Group.headerTitle
        case .coffeeChat:
            return I18N.Home.CoffeeChat.headerTitle
        case .announcement:
            return I18N.Home.Announcements.headerTitle
        default:
            return ""
        }
    }
}
