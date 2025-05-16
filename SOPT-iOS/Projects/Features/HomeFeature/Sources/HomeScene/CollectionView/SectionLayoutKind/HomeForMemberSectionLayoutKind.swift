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
    case insight
    case socialLinks
    
    var title: String {
        switch self {
        case .appService:
            return I18N.Home.AppService.headerTitle
        case .insight:
            return I18N.Home.Insight.headerTitle
        default:
            return ""
        }
    }
}

extension HomeForMemberSectionLayoutKind: HomeSectionKindProtocol { }
