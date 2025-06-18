//
//  HomeForVisitorSectionLayoutKind.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 12/9/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

enum HomeForVisitorSectionLayoutKind: Int, CaseIterable {
    case dashBoard
    case mainProduct
    case appService
}

extension HomeForVisitorSectionLayoutKind: HomeSectionUIConfigurable {
    var headerTitle: String {
        switch self {
        case .mainProduct:
            return I18N.Home.MainProduct.headerTitleForVisitor
        case .appService:
            return I18N.Home.AppService.headerTitle
        default:
            return ""
        }
    }
    
    var shouldShowFireIcon: Bool {
        return false
    }
    
    var shouldShowViewAllButton: Bool {
        return false
    }
}
